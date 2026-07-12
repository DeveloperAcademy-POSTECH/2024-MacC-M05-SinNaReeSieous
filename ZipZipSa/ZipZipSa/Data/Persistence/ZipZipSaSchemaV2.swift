//
//  ZipZipSaSchemaV2.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// 현재 스키마 (V2).
/// V1 대비 변경(전부 가산적 — 경량 마이그레이션으로 자동 처리):
/// - ChecklistAnswerData 신설: 답변 blob([Int: Set<Int>] JSON)의 정규화. 질문 영구 code 키.
/// - ChecklistTemplateData 신설: 커스텀 체크리스트 템플릿.
/// - HomeData: checklistAnswers 관계, usedQuestionCodes 추가. 레거시 blob은 백업으로 유지.
/// - User: templates 관계, activeTemplateID 추가.
///
/// blob → 레코드 데이터 이관은 스키마 마이그레이션이 아니라 앱 시작 시
/// LegacyBlobMigrator가 수행한다 (실패해도 앱이 뜨고, 유닛 테스트 가능).
enum ZipZipSaSchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [User.self, ChecklistCategoryData.self, ChecklistTemplateData.self,
         HomeData.self, ChecklistAnswerData.self, RentalFeeData.self,
         LocationData.self, FacilityData.self, MemoData.self, HazardData.self]
    }
}

/// 스키마 버전 이력. 새 버전을 추가할 때 schemas와 stages에 등록한다.
enum ZipZipSaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [ZipZipSaSchemaV1.self, ZipZipSaSchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: ZipZipSaSchemaV1.self,
        toVersion: ZipZipSaSchemaV2.self
    )
}
