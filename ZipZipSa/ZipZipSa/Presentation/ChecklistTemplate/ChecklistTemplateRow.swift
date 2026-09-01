//
//  ChecklistTemplateRow.swift
//  ZipZipSa
//

import Foundation

/// 체크리스트 목록의 한 행.
/// 기본 체크리스트는 저장된 템플릿이 아니라 동적 규칙이므로 가상 행으로 표현한다.
enum ChecklistTemplateRow: Identifiable {
    case `default`
    case custom(ChecklistTemplateData)

    var id: String {
        switch self {
        case .default: "default"
        case .custom(let template): template.id.uuidString
        }
    }

    var template: ChecklistTemplateData? {
        switch self {
        case .default: nil
        case .custom(let template): template
        }
    }

    /// 표시 순서: 대표(사용 중)로 표시된 행이 항상 맨 위,
    /// 나머지는 기본 → 생성 순서를 유지한다.
    /// markedID가 nil이면 기본 체크리스트가 대표이므로 이미 맨 위다.
    static func ordered(
        templates: [ChecklistTemplateData],
        markedID: UUID?
    ) -> [ChecklistTemplateRow] {
        var rows: [ChecklistTemplateRow] =
            [.default] + templates.sorted { $0.createdAt < $1.createdAt }.map(Self.custom)

        if let markedID,
           let index = rows.firstIndex(where: { $0.template?.id == markedID }),
           index != 0 {
            rows.insert(rows.remove(at: index), at: 0)
        }
        return rows
    }
}
