//
//  LegacyBlobMigrationTests.swift
//  ZipZipSaTests
//

import Foundation
import Testing
import SwiftData
@testable import ZipZipSa

/// V1 blob → V2 답변 레코드 이관 검증.
/// 인메모리 컨테이너에 v1.0.2 형식의 blob을 심고 LegacyBlobMigrator를 돌려 확인한다.
@MainActor
struct LegacyBlobMigrationTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
            configurations: config
        )
    }

    /// v1.0.2 앱이 남겼을 형태 그대로의 HomeData를 만든다 (레코드 없음, blob만 존재).
    private func makeLegacyHome(
        in context: ModelContext,
        favorites: [ChecklistCategory],
        legacyAnswers: [Int: Set<Int>]
    ) throws -> HomeData {
        let home = HomeData(homeName: "테스트집")
        home.selectedCategoryData = favorites.map { ChecklistCategoryData(rawValue: $0.rawValue) }
        home.answerData = try JSONEncoder().encode(legacyAnswers)
        context.insert(home)
        return home
    }

    @Test func 관심_카테고리_사용자는_기존_세트를_템플릿으로_이관받는다() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)
        let favorites: [ChecklistCategory] = [.security, .cleanliness]
        user.favoriteCategoryData = favorites.map {
            ChecklistCategoryData(rawValue: $0.rawValue)
        }

        LegacyBlobMigrator.migrateFavoriteCategoryTemplate(context: context)

        let migrated = user.templates.first {
            $0.name == ZipLiteral.ChecklistTemplate.favoriteMigratedName
        }
        // 예전 기본 규칙(빠르게+기본+관심 카테고리 추가)이 그대로 담긴다
        let expected = ChecklistScoringService
            .filteredItems(selectedCategories: [.security, .cleanliness])
            .map(\.code)
        #expect(migrated?.questionCodes == expected)
        #expect(migrated!.questionCodes.count > QuestionProvider.defaultQuestions().count)
        // 기본을 쓰던 사용자는 이관된 템플릿을 그대로 이어 쓴다
        #expect(user.activeTemplateID == migrated?.id)

        // 두 번 돌아도 복제되지 않는다
        LegacyBlobMigrator.migrateFavoriteCategoryTemplate(context: context)
        #expect(user.templates.count == 1)
    }

    @Test func 관심_카테고리가_없으면_템플릿을_만들지_않는다() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)

        LegacyBlobMigrator.migrateFavoriteCategoryTemplate(context: context)

        #expect(user.templates.isEmpty)
        #expect(user.activeTemplateID == nil)
    }

    @Test func 이관은_대표_템플릿을_이미_가진_사용자의_설정을_건드리지_않는다() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)
        user.favoriteCategoryData = [ChecklistCategoryData(rawValue: "security")]
        let mine = ChecklistTemplateData(name: "내 체크리스트", questionCodes: ["ext-01"])
        user.templates.append(mine)
        user.activeTemplateID = mine.id

        LegacyBlobMigrator.migrateFavoriteCategoryTemplate(context: context)

        #expect(user.templates.count == 2)
        #expect(user.activeTemplateID == mine.id)
    }

    @Test func 이관_후_레코드_수와_값이_정확하다() throws {
        let container = try makeContainer()
        let legacy: [Int: Set<Int>] = [0: [1], 3: [0, 2], 30: [1], 56: [0]]
        let home = try makeLegacyHome(in: container.mainContext,
                                      favorites: ChecklistAnswerFixtures.allFavorites,
                                      legacyAnswers: legacy)

        LegacyBlobMigrator.migrate(home: home)

        // id 30이 두 code로 복제되므로 레코드는 5개
        #expect(home.checklistAnswers.count == 5)
        let byCode = home.checklistAnswersByCode
        #expect(byCode["ext-01"] == [1])
        #expect(byCode["ext-04"] == [0, 2])
        #expect(byCode["lvr-21"] == [1])
        #expect(byCode["kit-05"] == [1])
        #expect(byCode == LegacyChecklistIDMap.fromLegacy(legacy))

        // 기록 당시 질문 세트 스냅샷이 채워진다
        let expectedCodes = ChecklistScoringService
            .filteredItems(selectedCategories: ChecklistAnswerFixtures.allFavorites)
            .map(\.code)
        #expect(home.usedQuestionCodes == expectedCodes)

        // blob 원본은 그대로 남는다 (롤백 백업)
        #expect(home.answerData != nil)
    }

    @Test func 이관_전후_카테고리_점수가_동일하다() throws {
        // 골든 테스트와 같은 픽스처를 v1 blob 형태로 심고,
        // 이관된 레코드에서 파생한 점수가 골든 리터럴과 일치하는지 확인한다.
        let container = try makeContainer()
        let favorites = ChecklistAnswerFixtures.twoFavorites
        let legacy = LegacyChecklistIDMap.toLegacy(ChecklistAnswerFixtures.evenIdsFirstOption)
        let home = try makeLegacyHome(in: container.mainContext,
                                      favorites: favorites,
                                      legacyAnswers: legacy)

        LegacyBlobMigrator.migrate(home: home)

        let items = ChecklistScoringService.filteredItems(selectedCategories: favorites)
        let answers = home.checklistAnswersByCode
        let scores = ChecklistScoringService.deriveScores(answers: answers)
        let category = ChecklistScoringService.categoryScores(
            items: items, selectedCategories: favorites, scores: scores
        )

        // ChecklistScoringGoldenTests.두_관심카테고리_짝수id만_첫옵션_응답 과 동일한 리터럴
        #expect(category == [
            "cleanliness": 6.0, "insectproof": 2.0, "security": 7.5,
            "soundproof": 3.0, "sunlight": 1.0, "ventilation": 1.0
        ])

        let hazards = ChecklistScoringService.hazards(items: items, answers: answers)
        #expect(hazards.map(\.rawValue) == ["cockroach", "privacy", "noise", "waterCold"])
    }

    @Test func 이관은_멱등하다() throws {
        let container = try makeContainer()
        let legacy: [Int: Set<Int>] = [0: [1], 30: [0]]
        let home = try makeLegacyHome(in: container.mainContext,
                                      favorites: ChecklistAnswerFixtures.allFavorites,
                                      legacyAnswers: legacy)

        LegacyBlobMigrator.migrate(home: home)
        let firstCount = home.checklistAnswers.count
        let firstAnswers = home.checklistAnswersByCode

        LegacyBlobMigrator.migrate(home: home)

        #expect(home.checklistAnswers.count == firstCount)
        #expect(home.checklistAnswersByCode == firstAnswers)
    }

    @Test func 답변이_없는_집도_스냅샷은_채워진다() throws {
        let container = try makeContainer()
        let home = HomeData(homeName: "빈집")
        container.mainContext.insert(home)

        LegacyBlobMigrator.migrate(home: home)

        #expect(home.checklistAnswers.isEmpty)
        #expect(!home.usedQuestionCodes.isEmpty)
    }

    @Test func migrateIfNeeded는_완료_후_다시_돌지_않는다() throws {
        let suiteName = "LegacyBlobMigrationTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let container = try makeContainer()
        let legacy: [Int: Set<Int>] = [0: [1]]
        let home = try makeLegacyHome(in: container.mainContext,
                                      favorites: ChecklistAnswerFixtures.allFavorites,
                                      legacyAnswers: legacy)

        LegacyBlobMigrator.migrateIfNeeded(context: container.mainContext, defaults: defaults)
        #expect(defaults.integer(forKey: LegacyBlobMigrator.dataVersionKey) == LegacyBlobMigrator.currentDataVersion)
        #expect(home.checklistAnswers.count == 1)

        // 플래그가 올라간 뒤에는 레코드를 지워도 다시 이관하지 않는다
        home.checklistAnswers = []
        LegacyBlobMigrator.migrateIfNeeded(context: container.mainContext, defaults: defaults)
        #expect(home.checklistAnswers.isEmpty)
    }
}
