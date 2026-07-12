//
//  ChecklistViewModelTests.swift
//  ZipZipSaTests
//

import Foundation
import Testing
import SwiftData
@testable import ZipZipSa

@MainActor
struct ChecklistViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
            configurations: config
        )
    }

    private func makeHome(in container: ModelContainer) -> HomeData {
        let home = HomeData(homeName: "테스트집")
        container.mainContext.insert(home)
        return home
    }

    @Test func homeHunt_모드는_유저_관심사를_쓰고_스냅샷을_남긴다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let favorites: [ChecklistCategory] = [.security, .soundproof]

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: favorites)

        #expect(vm.selectedCategories == favorites)
        #expect(home.selectedCategories == favorites)
        #expect(vm.navigationTitle == ZipLiteral.Checklist.navigationTitle)
        #expect(vm.bottomButtonText(for: .exterior) == ZipLiteral.Checklist.bottomButton)
        #expect(vm.bottomButtonText(for: .livingRoom) == "다음")
    }

    @Test func review_모드는_기록_당시_스냅샷을_쓴다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        home.selectedCategoryData = [ChecklistCategoryData(rawValue: "sunlight")]

        let vm = ChecklistViewModel(mode: .review)
        vm.start(homeData: home, userFavorites: [.security]) // 유저 관심사는 무시돼야 함

        #expect(vm.selectedCategories == [.sunlight])
        #expect(vm.bottomButtonText(for: .exterior) == "저장")
    }

    @Test func 답변_토글은_점수를_함께_갱신한다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: ChecklistAnswerFixtures.allFavorites)

        let twoChoices = ChecklistItem.checklistItems.first { item in
            if case .twoChoices = item.question.answerType { return true }
            return false
        }!

        vm.toggleAnswer(item: twoChoices, index: 1)
        #expect(vm.isSelected(item: twoChoices, index: 1))
        #expect(vm.scores[twoChoices.code] == 2)

        // 같은 버튼 재탭 = 선택 해제, 점수는 미응답 기본값 1
        vm.toggleAnswer(item: twoChoices, index: 1)
        #expect(!vm.isSelected(item: twoChoices, index: 1))
        #expect(vm.scores[twoChoices.code] == 1)

        // multiSelect는 누적 선택
        let multiSelect = ChecklistItem.checklistItems.first { item in
            if case .multiSelect = item.question.answerType { return true }
            return false
        }!
        vm.toggleAnswer(item: multiSelect, index: 0)
        vm.toggleAnswer(item: multiSelect, index: 1)
        #expect(vm.answers[multiSelect.code] == [0, 1])
        #expect(vm.scores[multiSelect.code] == ChecklistScoringService.answerScore(for: multiSelect, selection: [0, 1]))
    }

    @Test func 저장_후_다시_시작하면_답변이_보존된다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let favorites = ChecklistAnswerFixtures.allFavorites

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: favorites)
        let item = vm.filteredItems[0]
        vm.toggleAnswer(item: item, index: 1)
        vm.save(to: home)

        // 레코드와 레거시 blob 미러가 모두 기록된다
        #expect(!home.checklistAnswers.isEmpty)
        #expect(home.answerData != nil)
        #expect(home.usedQuestionCodes == vm.filteredItems.map(\.code))

        let vm2 = ChecklistViewModel(mode: .review)
        vm2.start(homeData: home, userFavorites: [])
        #expect(vm2.answers[item.code] == [1])
        #expect(vm2.scores[item.code] == 2)
    }

    // MARK: - 커스텀 템플릿

    private func makeTemplate(
        in container: ModelContainer,
        codes: [String],
        name: String = "커스텀",
        activate: Bool = true
    ) -> ChecklistTemplateData {
        let user = User()
        let template = ChecklistTemplateData(name: name, questionCodes: codes)
        user.templates.append(template)
        if activate {
            user.activeTemplateID = template.id
        }
        container.mainContext.insert(user)
        return template
    }

    @Test func 커스텀_템플릿은_선택한_질문만_노출하고_카테고리는_합집합이다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        // 서로 다른 selectable 카테고리의 질문 두 개를 고른다
        let items = ChecklistItem.checklistItems.filter { $0.basicCategory.isSelectable }
        let first = items.first!
        let second = items.last { $0.basicCategory != first.basicCategory }!
        let template = makeTemplate(in: container, codes: [first.code, second.code])

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: [.sunlight], activeTemplate: template)

        #expect(Set(vm.filteredItems.map(\.code)) == Set([first.code, second.code]))
        let expected = QuestionProvider.scoringCategories(for: [first, second])
        #expect(vm.selectedCategories == expected)
        // 유저 관심사가 아니라 질문 세트 기준으로 스냅샷이 남는다
        #expect(Set(home.selectedCategories) == Set(expected))
    }

    @Test func 커스텀_템플릿_저장은_템플릿_질문세트를_스냅샷으로_남긴다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let codes = ChecklistItem.checklistItems.prefix(3).map(\.code)
        let template = makeTemplate(in: container, codes: Array(codes))

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: [], activeTemplate: template)
        vm.save(to: home)

        #expect(Set(home.usedQuestionCodes) == Set(codes))
    }

    @Test func applyResult는_커스텀_세트에_없는_카테고리를_결과에서_뺀다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        // security 질문 하나만 선택
        let securityItem = ChecklistItem.checklistItems.first {
            $0.basicCategory == .security && $0.crossTip.isEmpty
        }!
        let template = makeTemplate(in: container, codes: [securityItem.code])

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: ChecklistAnswerFixtures.allFavorites, activeTemplate: template)
        vm.applyResult(to: home)

        let maxScores = home.loadDictionary(data: home.resultMaxScoreData, type: [String: Float].self)
        #expect(maxScores?.keys.contains(ChecklistCategory.security.rawValue) == true)
        #expect(maxScores?.keys.contains(ChecklistCategory.sunlight.rawValue) != true)
    }

    @Test func review는_기록_당시_질문_스냅샷을_재현한다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let codes = ChecklistItem.checklistItems.prefix(2).map(\.code)
        home.usedQuestionCodes = Array(codes)

        let vm = ChecklistViewModel(mode: .review)
        vm.start(homeData: home, userFavorites: [])

        #expect(Set(vm.filteredItems.map(\.code)) == Set(codes))
    }

    @Test func review는_스냅샷이_비어있으면_동적_규칙으로_폴백한다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        home.selectedCategoryData = [ChecklistCategoryData(rawValue: "security")]

        let vm = ChecklistViewModel(mode: .review)
        vm.start(homeData: home, userFavorites: [])

        let expected = QuestionProvider.questions(selectedCategories: [.security]).map(\.code)
        #expect(vm.filteredItems.map(\.code) == expected)
    }

    @Test func switchTemplate은_질문세트를_바꾸고_답변은_유지한다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let codes = ChecklistItem.checklistItems.prefix(3).map(\.code)
        let template = makeTemplate(in: container, codes: Array(codes), activate: false)

        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: [.security])
        let item = vm.filteredItems[0]
        vm.toggleAnswer(item: item, index: 1)

        vm.switchTemplate(template, homeData: home)
        #expect(Set(vm.filteredItems.map(\.code)) == Set(codes))
        // 답변은 code 기반이라 전환해도 유지된다
        #expect(vm.answers[item.code] == [1])

        // 기본으로 되돌리면 관심 카테고리 규칙으로 복귀
        vm.switchTemplate(nil, homeData: home)
        #expect(vm.selectedCategories == [.security])
        #expect(vm.filteredItems.map(\.code) == QuestionProvider.questions(selectedCategories: [.security]).map(\.code))
    }

    @Test func applyResult는_결과_카드_필드를_채운다() throws {
        let container = try makeContainer()
        let home = makeHome(in: container)
        let vm = ChecklistViewModel(mode: .homeHunt)
        vm.start(homeData: home, userFavorites: ChecklistAnswerFixtures.allFavorites)

        vm.applyResult(to: home)

        let scores = home.loadDictionary(data: home.resultScoreData, type: [String: Float].self)
        let maxScores = home.loadDictionary(data: home.resultMaxScoreData, type: [String: Float].self)
        // 전부 미응답이어도 기본값 가산 규칙으로 카테고리 점수가 존재해야 한다
        #expect(scores?.isEmpty == false)
        #expect(maxScores?.isEmpty == false)
    }
}
