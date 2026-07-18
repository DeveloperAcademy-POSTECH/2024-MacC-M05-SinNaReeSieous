//
//  ChecklistTemplatePreset.swift
//  ZipZipSa
//

import Foundation

/// 체크리스트 생성 시 제공하는 기본 템플릿 프리셋.
/// 질문 유형(빠르게/기본/추가) 조합으로 시작 질문 세트를 정의한다.
enum ChecklistTemplatePreset: CaseIterable, Identifiable {
    /// 빠르게 + 기본
    case basic
    /// 빠르게 + 기본 + 추가 (전체)
    case detailed
    /// 빠르게만
    case quick
    /// 빈 세트에서 직접 추가
    case custom

    var id: Self { self }

    var name: String {
        switch self {
        case .basic: ZipLiteral.ChecklistTemplate.presetBasic
        case .detailed: ZipLiteral.ChecklistTemplate.presetDetailed
        case .quick: ZipLiteral.ChecklistTemplate.presetQuick
        case .custom: ZipLiteral.ChecklistTemplate.presetCustom
        }
    }

    private var includedTypes: [ChecklistType] {
        switch self {
        case .basic: [.quick, .basic]
        case .detailed: [.quick, .basic, .advanced]
        case .quick: [.quick]
        case .custom: []
        }
    }

    /// 프리셋에 포함되는 질문 code (카탈로그 순서).
    var questionCodes: [String] {
        ChecklistItem.checklistItems
            .filter { includedTypes.contains($0.checkListType) }
            .map(\.code)
    }

    var questionCount: Int { questionCodes.count }
}
