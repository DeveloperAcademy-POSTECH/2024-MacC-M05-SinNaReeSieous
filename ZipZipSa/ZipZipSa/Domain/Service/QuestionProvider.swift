//
//  QuestionProvider.swift
//  ZipZipSa
//

import Foundation

/// 화면에 노출할 질문 세트를 결정하는 단일 창구.
enum QuestionProvider {

    /// 기본 체크리스트 = "기본" 템플릿 프리셋(빠르게 + 기본)과 같은 세트.
    ///
    /// 예전에는 여기에 관심 카테고리에 해당하는 '추가' 질문까지 붙였다. 그 탓에
    /// 체크리스트 관리 화면의 "기본"과 만들기의 "기본" 프리셋이 서로 다른 문항 수를
    /// 보여줬고, 관심 카테고리 선택(온보딩)이 없어지는 방향이라 프리셋 정의로 통일했다.
    ///
    /// 관심 카테고리를 골라둔 기존 사용자의 세트는 LegacyBlobMigrator가
    /// 커스텀 템플릿으로 옮겨주고, 지난 기록 재현은
    /// ChecklistScoringService.filteredItems가 계속 담당한다.
    static func defaultQuestions() -> [ChecklistItem] {
        let codes = Set(ChecklistTemplatePreset.basic.questionCodes)
        return ChecklistItem.checklistItems.filter { codes.contains($0.code) }
    }

    /// 템플릿 기반 질문 세트. 템플릿이 없거나 기본 템플릿이면 기본 세트를 쓴다.
    static func questions(for template: ChecklistTemplateData?) -> [ChecklistItem] {
        guard let template, !template.isDefault else {
            return defaultQuestions()
        }
        // 저장된 템플릿에 은퇴한 질문이 남아 있어도 새 체크리스트에는 내보내지 않는다
        let codes = Set(template.questionCodes)
        return ChecklistItem.activeItems.filter { codes.contains($0.code) }
    }

    /// 커스텀 질문 세트의 채점 대상 카테고리: 질문들의 대표 카테고리 중
    /// 선택 가능(isSelectable)한 것의 합집합. ChecklistCategory.allCases 순서로 정렬해
    /// 같은 세트면 항상 같은 결과를 보장한다.
    static func scoringCategories(for items: [ChecklistItem]) -> [ChecklistCategory] {
        let categories = Set(items.map(\.basicCategory)).filter(\.isSelectable)
        return ChecklistCategory.allCases.filter { categories.contains($0) }
    }
}
