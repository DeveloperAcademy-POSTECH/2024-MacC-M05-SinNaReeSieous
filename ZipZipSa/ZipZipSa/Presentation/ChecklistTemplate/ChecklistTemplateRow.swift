//
//  ChecklistTemplateRow.swift
//  ZipZipSa
//

import Foundation

/// 체크리스트 목록의 표시 순서.
/// 기본 체크리스트도 저장된 템플릿이라(DefaultTemplateSeeder) 다른 체크리스트와 똑같이 다룬다.
enum ChecklistTemplateRow {

    /// 표시 순서: 대표(사용 중)로 표시된 체크리스트가 항상 맨 위,
    /// 나머지는 생성 순서를 유지한다(기본은 가장 먼저 만들어진 것으로 저장된다).
    static func ordered(
        templates: [ChecklistTemplateData],
        markedID: UUID?
    ) -> [ChecklistTemplateData] {
        var rows = templates.sorted { $0.createdAt < $1.createdAt }

        if let markedID,
           let index = rows.firstIndex(where: { $0.id == markedID }),
           index != 0 {
            rows.insert(rows.remove(at: index), at: 0)
        }
        return rows
    }
}
