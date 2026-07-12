//
//  ChecklistTemplateData.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// 사용자가 만든 커스텀 체크리스트 템플릿 (스키마 V2).
/// 질문 풀(ChecklistItem.checklistItems)에서 고른 질문 code 목록을 저장한다.
/// Phase 3에서는 모델만 도입하고, 편집 UI는 커스텀 체크리스트 기능에서 붙인다.
@Model
final class ChecklistTemplateData {
    @Attribute(.unique)
    var id: UUID

    var name: String

    /// 이 템플릿에 포함된 질문 code 목록. 순서는 의미 없다(노출 순서는 공간·연번 기준).
    var questionCodes: [String]

    var createdAt: Date

    /// 기본 템플릿 여부. 기본 템플릿은 "basic 전부 + 관심 카테고리 advanced"라는
    /// 동적 규칙을 뜻하므로 questionCodes를 비워둔다.
    var isDefault: Bool

    init(
        id: UUID = UUID(),
        name: String,
        questionCodes: [String] = [],
        createdAt: Date = .now,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.questionCodes = questionCodes
        self.createdAt = createdAt
        self.isDefault = isDefault
    }
}
