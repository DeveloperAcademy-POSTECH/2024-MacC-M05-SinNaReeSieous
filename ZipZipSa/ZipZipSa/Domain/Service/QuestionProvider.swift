//
//  QuestionProvider.swift
//  ZipZipSa
//

import Foundation

/// 화면에 노출할 질문 세트를 결정하는 단일 창구.
/// 커스텀 체크리스트의 진입점: 템플릿 편집 UI가 생기면
/// questions(for:selectedCategories:)에 사용자의 활성 템플릿을 넘기기만 하면 된다.
enum QuestionProvider {

    /// 기본 템플릿: 빠르게·기본 질문 전부 + 관심 카테고리에 해당하는 추가 질문.
    static func questions(selectedCategories: [ChecklistCategory]) -> [ChecklistItem] {
        ChecklistScoringService.filteredItems(selectedCategories: selectedCategories)
    }

    /// 템플릿 기반 질문 세트. 템플릿이 없거나 기본 템플릿이면 동적 규칙을 따른다.
    static func questions(
        for template: ChecklistTemplateData?,
        selectedCategories: [ChecklistCategory]
    ) -> [ChecklistItem] {
        guard let template, !template.isDefault else {
            return questions(selectedCategories: selectedCategories)
        }
        let codes = Set(template.questionCodes)
        return ChecklistItem.checklistItems.filter { codes.contains($0.code) }
    }

    /// 커스텀 질문 세트의 채점 대상 카테고리: 질문들의 대표 카테고리 중
    /// 선택 가능(isSelectable)한 것의 합집합. ChecklistCategory.allCases 순서로 정렬해
    /// 같은 세트면 항상 같은 결과를 보장한다.
    static func scoringCategories(for items: [ChecklistItem]) -> [ChecklistCategory] {
        let categories = Set(items.map(\.basicCategory)).filter(\.isSelectable)
        return ChecklistCategory.allCases.filter { categories.contains($0) }
    }
}
