//
//  ZipZipSaApp.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

@main
struct ZipZipSaApp: App {

    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Schema(versionedSchema: ZipZipSaSchemaV2.self),
                migrationPlan: ZipZipSaMigrationPlan.self
            )
        } catch {
            fatalError("ModelContainer 생성 실패: \(error)")
        }
        container.mainContext.autosaveEnabled = true
        LegacyBlobMigrator.migrateIfNeeded(context: container.mainContext)
        // 이관(카테고리 반영 체크리스트) 뒤에 돌려야 그 체크리스트를 쓰던 사용자의 대표가 유지된다
        DefaultTemplateSeeder.seedIfNeeded(context: container.mainContext)
        ZZSAlertAppearance.apply()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
