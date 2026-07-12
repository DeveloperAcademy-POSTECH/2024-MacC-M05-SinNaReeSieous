//
//  ChecklistTemplateEditViewModelTests.swift
//  ZipZipSaTests
//

import Foundation
import Testing
import SwiftData
@testable import ZipZipSa

@MainActor
struct ChecklistTemplateEditViewModelTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
            configurations: config
        )
    }

    private func makeUser(in container: ModelContainer, favorites: [ChecklistCategory] = []) -> User {
        let user = User(favoriteCategoryData: favorites.map { ChecklistCategoryData(rawValue: $0.rawValue) })
        container.mainContext.insert(user)
        return user
    }

    @Test func 신규는_기본_규칙_세트로_시작한다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container, favorites: [.security])

        let vm = ChecklistTemplateEditViewModel()
        vm.start(user: user)

        let expected = Set(QuestionProvider.questions(selectedCategories: [.security]).map(\.code))
        #expect(vm.selectedCodes == expected)
        #expect(vm.isNew)
        #expect(!vm.isPrimary)
    }

    @Test func 수정은_기존_템플릿_값을_불러온다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)
        let codes = ChecklistItem.checklistItems.prefix(2).map(\.code)
        let template = ChecklistTemplateData(name: "내꺼", questionCodes: Array(codes))
        user.templates.append(template)
        user.activeTemplateID = template.id

        let vm = ChecklistTemplateEditViewModel(template: template)
        vm.start(user: user)

        #expect(vm.name == "내꺼")
        #expect(vm.selectedCodes == Set(codes))
        #expect(vm.isPrimary)
    }

    @Test func 저장은_새_템플릿을_만들고_대표를_지정한다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)
        let item = ChecklistItem.checklistItems[0]

        let vm = ChecklistTemplateEditViewModel()
        vm.start(user: user)
        vm.name = "커스텀"
        vm.isPrimary = true
        vm.remove(ChecklistItem.checklistItems[1]) // 임의 조작
        vm.add(item)
        vm.save(context: container.mainContext)

        #expect(user.templates.count == 1)
        let saved = user.templates[0]
        #expect(saved.name == "커스텀")
        #expect(user.activeTemplateID == saved.id)
        #expect(saved.questionCodes.contains(item.code))
    }

    @Test func 이름이_비어있으면_자동_이름으로_저장한다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)

        let vm = ChecklistTemplateEditViewModel()
        vm.start(user: user)
        vm.name = "   "
        vm.save(context: container.mainContext)

        #expect(user.templates[0].name == "내 체크리스트 1")
    }

    @Test func 대표_해제하고_저장하면_기본으로_폴백한다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)
        let template = ChecklistTemplateData(name: "대표였음", questionCodes: [ChecklistItem.checklistItems[0].code])
        user.templates.append(template)
        user.activeTemplateID = template.id

        let vm = ChecklistTemplateEditViewModel(template: template)
        vm.start(user: user)
        vm.isPrimary = false
        vm.save(context: container.mainContext)

        #expect(user.activeTemplateID == nil)
        #expect(user.activeTemplate == nil)
    }

    @Test func 질문이_없으면_저장하지_않는다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)

        let vm = ChecklistTemplateEditViewModel()
        vm.start(user: user)
        for item in ChecklistItem.checklistItems {
            vm.remove(item)
        }
        #expect(!vm.isValid)
        vm.save(context: container.mainContext)
        #expect(user.templates.isEmpty)
    }

    @Test func 활성_템플릿이_삭제되면_activeTemplate은_nil이다() throws {
        let container = try makeContainer()
        let user = makeUser(in: container)
        let template = ChecklistTemplateData(name: "삭제될것", questionCodes: [ChecklistItem.checklistItems[0].code])
        user.templates.append(template)
        user.activeTemplateID = template.id

        user.templates.removeAll { $0.id == template.id }
        container.mainContext.delete(template)

        // dangling ID여도 크래시 없이 nil → 기본 규칙 폴백
        #expect(user.activeTemplate == nil)
    }
}
