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
        // 이관(선택 카테고리 반영 체크리스트) 뒤에 돌려야 그 체크리스트를 쓰던 사용자의 대표가 유지된다
        DefaultTemplateSeeder.seedIfNeeded(context: container.mainContext)
        ZZSAlertAppearance.apply()
        ZZSNavigationBarAppearance.apply()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 시스템 툴바 버튼(뒤로·닫기·만들기 등)을 앱 갈색으로 맞춘다.
                // 루트에 둬야 fullScreenCover/sheet로 띄운 화면까지 적용된다(안 두면 기본 파란색).
                .tint(Color.Button.tertiary)
        }
        .modelContainer(container)
    }
}
