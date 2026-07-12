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
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
