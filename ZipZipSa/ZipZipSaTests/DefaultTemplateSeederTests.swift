//
//  DefaultTemplateSeederTests.swift
//  ZipZipSaTests
//

import Foundation
import Testing
import SwiftData
@testable import ZipZipSa

@MainActor
struct DefaultTemplateSeederTests {

    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
            configurations: config
        )
    }

    private func makeDefaults() -> (UserDefaults, String) {
        let suiteName = "DefaultTemplateSeederTests-\(UUID().uuidString)"
        return (UserDefaults(suiteName: suiteName)!, suiteName)
    }

    @Test func 대표가_없던_사용자는_저장된_기본이_대표가_된다() throws {
        let (defaults, suiteName) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)

        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)

        #expect(user.templates.count == 1)
        let seeded = try #require(user.templates.first)
        #expect(seeded.name == ZipLiteral.ChecklistTemplate.defaultTemplateName)
        #expect(!seeded.isDefault)
        #expect(Set(seeded.questionCodes) == Set(QuestionProvider.defaultQuestions().filter { !$0.isRetired }.map(\.code)))
        #expect(user.activeTemplateID == seeded.id)
    }

    @Test func 이미_대표가_있으면_대표를_바꾸지_않는다() throws {
        let (defaults, suiteName) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)
        let mine = ChecklistTemplateData(name: "내 체크리스트", questionCodes: ["ext-02"])
        user.templates.append(mine)
        user.activeTemplateID = mine.id

        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)

        #expect(user.templates.count == 2)
        #expect(user.activeTemplateID == mine.id)
    }

    @Test func 한_번_만든_뒤_지워도_다시_만들지_않는다() throws {
        let (defaults, suiteName) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let container = try makeContainer()
        let context = container.mainContext
        let user = UserService.fetchOrCreateUser(context: context)

        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)
        user.templates.removeAll()
        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)

        #expect(user.templates.isEmpty)
    }

    @Test func 사용자가_없으면_만들지_않고_다음에_다시_시도한다() throws {
        let (defaults, suiteName) = makeDefaults()
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let container = try makeContainer()
        let context = container.mainContext

        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)
        #expect(!defaults.bool(forKey: DefaultTemplateSeeder.seededKey))

        let user = UserService.fetchOrCreateUser(context: context)
        DefaultTemplateSeeder.seedIfNeeded(context: context, defaults: defaults)
        #expect(user.templates.count == 1)
    }

    @Test func 대표는_항상_맨_위에_기본은_생성_순서상_가장_먼저_온다() throws {
        let basic = ChecklistTemplateData(name: "기본", questionCodes: ["ext-02"], createdAt: .distantPast)
        let first = ChecklistTemplateData(name: "첫째", questionCodes: ["ext-02"], createdAt: Date(timeIntervalSince1970: 1))
        let second = ChecklistTemplateData(name: "둘째", questionCodes: ["ext-02"], createdAt: Date(timeIntervalSince1970: 2))

        let rows = ChecklistTemplateRow.ordered(templates: [second, first, basic], markedID: second.id)

        #expect(rows.map(\.name) == ["둘째", "기본", "첫째"])
    }
}
