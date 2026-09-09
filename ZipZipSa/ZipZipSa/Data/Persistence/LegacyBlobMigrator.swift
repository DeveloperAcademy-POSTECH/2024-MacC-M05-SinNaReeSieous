//
//  LegacyBlobMigrator.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// V1 레거시 blob(answerData: [Int: Set<Int>] JSON)을 V2 답변 레코드로 이관한다.
///
/// 스키마 마이그레이션(SwiftData custom stage)이 아니라 앱 시작 시 실행하는 이유:
/// - 순수 Swift 로직이라 인메모리 컨테이너로 유닛 테스트할 수 있다.
/// - 실패해도 앱은 뜬다. blob 원본은 건드리지 않으므로 다음 실행에서 재시도된다.
///
/// legacyID 30(두 질문에 중복 부여됐던 버그)은 LegacyChecklistIDMap이
/// 두 code(lvr-21, kit-05) 모두에 값을 복제해 기존 점수를 정확히 보존한다.
///
/// 이관 완료 플래그는 UserDefaults에 둔다. User 모델 필드로 두지 않는 이유:
/// - 마이그레이터는 온보딩(User 생성) 전에도 실행돼야 한다.
/// - 새 프로퍼티의 기본값은 기존 레코드에도 채워지므로, User 필드로는
///   "이관이 필요한 기존 사용자"를 구분할 수 없다.
enum LegacyBlobMigrator {

    static let dataVersionKey = "checklistDataVersion"
    static let currentDataVersion = 2

    /// 앱 시작 시 1회 호출. 이관이 끝났으면 즉시 반환한다.
    @MainActor
    static func migrateIfNeeded(context: ModelContext, defaults: UserDefaults = .standard) {
        guard defaults.integer(forKey: dataVersionKey) < currentDataVersion else { return }

        do {
            let homes = try context.fetch(FetchDescriptor<HomeData>())
            for home in homes {
                migrate(home: home)
            }
            try context.save()
            defaults.set(currentDataVersion, forKey: dataVersionKey)
        } catch {
            // 플래그를 올리지 않으므로 다음 실행에서 재시도된다. blob 원본은 무손상.
        }
    }

    /// 집 하나의 blob을 레코드로 변환한다. 이미 레코드가 있으면 건드리지 않는다(멱등).
    static func migrate(home: HomeData) {
        if home.usedQuestionCodes.isEmpty {
            home.usedQuestionCodes = ChecklistScoringService
                .filteredItems(selectedCategories: home.selectedCategories)
                .map(\.code)
        }

        guard home.checklistAnswers.isEmpty,
              let answerData = home.answerData,
              let legacy = try? JSONDecoder().decode([Int: Set<Int>].self, from: answerData) else {
            return
        }

        let modern = LegacyChecklistIDMap.fromLegacy(legacy)
        home.setChecklistAnswers(modern)
        // scoreData blob은 이관하지 않는다 — 답변에서 항상 파생 가능한 값이다.
    }
}
