//
//  QuestionProviderTests.swift
//  ZipZipSaTests
//

import Foundation
import Testing
import SwiftData
@testable import ZipZipSa

/// 질문 세트 결정(QuestionProvider)과 커스텀 템플릿 저장 모델 검증.
/// 커스텀 체크리스트 기능은 "템플릿 편집 UI → questionCodes 수정"만 만들면 되도록
/// 여기서 데이터 계층의 동작을 보장해둔다.
@MainActor
struct QuestionProviderTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
            configurations: config
        )
    }

    @Test func 템플릿이_없으면_기본_규칙을_따른다() {
        let favorites: [ChecklistCategory] = [.security]
        let questions = QuestionProvider.questions(for: nil, selectedCategories: favorites)
        let expected = ChecklistScoringService.filteredItems(selectedCategories: favorites)
        #expect(questions.map(\.code) == expected.map(\.code))
    }

    @Test func 기본_템플릿은_동적_규칙과_같다() {
        let favorites: [ChecklistCategory] = [.sunlight, .soundproof]
        let defaultTemplate = ChecklistTemplateData(name: "기본", isDefault: true)
        let questions = QuestionProvider.questions(for: defaultTemplate, selectedCategories: favorites)
        let expected = ChecklistScoringService.filteredItems(selectedCategories: favorites)
        #expect(questions.map(\.code) == expected.map(\.code))
    }

    @Test func 커스텀_템플릿은_고른_질문만_노출한다() {
        let codes = ["ext-01", "lvr-01", "kit-05", "toi-03"]
        let template = ChecklistTemplateData(name: "내 체크리스트", questionCodes: codes)

        let questions = QuestionProvider.questions(for: template, selectedCategories: [])

        #expect(Set(questions.map(\.code)) == Set(codes))
        // 카탈로그에 없는 code는 조용히 무시된다
        let withUnknown = ChecklistTemplateData(name: "잘못된", questionCodes: ["ext-01", "zzz-99"])
        let filtered = QuestionProvider.questions(for: withUnknown, selectedCategories: [])
        #expect(filtered.map(\.code) == ["ext-01"])
    }

    @Test func 커스텀_템플릿_질문으로도_점수_집계가_동작한다() {
        // 커스텀 조합에서 만점이 질문 세트에 맞춰 자동으로 줄어드는지 확인
        let codes = ["ext-01", "ext-02"] // 치안 advanced 질문 2개 (twoChoices)
        let template = ChecklistTemplateData(name: "치안만", questionCodes: codes)
        let items = QuestionProvider.questions(for: template, selectedCategories: [.security])

        let maxScores = ChecklistScoringService.maxCategoryScores(
            items: items, selectedCategories: [.security]
        )
        #expect(maxScores == ["security": 4.0]) // twoChoices 2개 × 만점 2.0

        let scores = ChecklistScoringService.deriveScores(answers: ["ext-01": [1]])
        let result = ChecklistScoringService.categoryScores(
            items: items, selectedCategories: [.security], scores: scores
        )
        #expect(result == ["security": 3.0]) // 응답 2.0 + 미응답 기본값 1.0
    }

    @Test func 유저_템플릿_저장과_활성_템플릿_조회가_동작한다() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let user = UserService.fetchOrCreateUser(context: context)
        let template = ChecklistTemplateData(name: "내 체크리스트", questionCodes: ["ext-01"])
        user.templates.append(template)
        user.activeTemplateID = template.id
        try context.save()

        let fetched = UserService.fetchUser(context: context)
        #expect(fetched?.templates.count == 1)
        let active = fetched?.templates.first { $0.id == fetched?.activeTemplateID }
        #expect(active?.name == "내 체크리스트")
        #expect(active?.questionCodes == ["ext-01"])

        // 템플릿 삭제 시 활성 참조가 남아도 기본 규칙으로 폴백된다
        user.templates.removeAll()
        try context.save()
        let questions = QuestionProvider.questions(
            for: fetched?.templates.first { $0.id == fetched?.activeTemplateID },
            selectedCategories: [.security]
        )
        #expect(!questions.isEmpty)
    }
}
