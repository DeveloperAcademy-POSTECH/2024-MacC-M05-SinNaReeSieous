//
//  ChecklistScoringService.swift
//  ZipZipSa
//

import Foundation

/// 체크리스트 점수 계산 규칙의 단일 소스.
/// 개별 질문의 점수 규칙은 ScoringRule(데이터)로 표현되고,
/// 이 서비스는 규칙을 적용해 집계만 한다. 상태가 없는 순수 함수 모음이라
/// 어떤 화면에서든 같은 입력이면 같은 결과를 보장한다.
///
/// 답변/점수 딕셔너리의 키는 질문의 영구 code(String)다.
enum ChecklistScoringService {

    /// 노출 대상 질문 필터: 빠르게·기본 전부 + 관심 카테고리에 해당하는 추가.
    /// 빠르게(quick)는 기본에서 세분화된 유형이므로, 기존 기본 세트와 동일한 결과를 유지한다.
    static func filteredItems(selectedCategories: [ChecklistCategory]) -> [ChecklistItem] {
        ChecklistItem.checklistItems.filter {
            let isAlwaysIncludedItem = $0.checkListType != .advanced
            let isSelectedCategoryCheckListItem = $0.checkListType == .advanced
            && selectedCategories.contains($0.basicCategory)
            return isAlwaysIncludedItem || isSelectedCategoryCheckListItem
        }
    }

    /// 질문 하나의 현재 선택 상태에 대한 점수.
    /// selection이 nil이면 선택 해제된 상태(미응답으로 되돌림)를 뜻한다.
    static func answerScore(for item: ChecklistItem, selection: Set<Int>?) -> Float {
        let rule = item.scoringRule
        if let optionScores = rule.optionScores {
            // 단일 선택형
            guard let selection, let index = selection.first,
                  optionScores.indices.contains(index) else {
                return rule.unansweredScore
            }
            return optionScores[index]
        } else {
            // 복수 선택형
            return Float(selection?.count ?? 0) * rule.perSelection + rule.baseScore
        }
    }

    /// 답변 세트 전체에서 질문별 점수를 파생시킨다.
    /// 점수는 답변에서 항상 계산 가능하므로 별도로 저장할 필요가 없다.
    static func deriveScores(answers: [String: Set<Int>]) -> [String: Float] {
        var scores: [String: Float] = [:]
        for (code, selection) in answers {
            guard let item = ChecklistItem.itemsByCode[code] else { continue }
            scores[code] = answerScore(for: item, selection: selection)
        }
        return scores
    }

    /// 카테고리별 획득 점수 집계.
    /// 미응답 질문은 규칙의 unansweredScore로 가산된다.
    static func categoryScores(
        items: [ChecklistItem],
        selectedCategories: [ChecklistCategory],
        scores: [String: Float]
    ) -> [String: Float] {
        var categoryScores: [String: Float] = [:]

        items.forEach { checklistItem in
            for category in scoredCategories(of: checklistItem, selectedCategories: selectedCategories) {
                let value = scores[checklistItem.code] ?? checklistItem.scoringRule.unansweredScore
                categoryScores[category.rawValue, default: 0.0] += value
            }
        }

        return categoryScores
    }

    /// 카테고리별 만점 집계.
    static func maxCategoryScores(
        items: [ChecklistItem],
        selectedCategories: [ChecklistCategory]
    ) -> [String: Float] {
        var categoryScores: [String: Float] = [:]

        items.forEach { checklistItem in
            for category in scoredCategories(of: checklistItem, selectedCategories: selectedCategories) {
                categoryScores[category.rawValue, default: 0.0] += checklistItem.scoringRule.maxScore
            }
        }

        return categoryScores
    }

    /// 위험 응답(첫 번째 옵션 단독 선택)이 달린 질문에서 위험요소를 수집한다.
    static func hazards(
        items: [ChecklistItem],
        answers: [String: Set<Int>]
    ) -> [Hazard] {
        var hazards: [Hazard] = []

        items.forEach { checklistItem in
            guard let hazard = checklistItem.hazard else {
                return
            }
            let hasHazard = answers[checklistItem.code] == [0]
            if hasHazard && !hazards.contains(hazard) {
                hazards.append(hazard)
            }
        }

        hazards.sort { $0.text < $1.text }

        return hazards
    }

    /// 이 질문의 점수가 반영되는 카테고리 목록.
    /// 대표 카테고리(선택 가능형인 경우) + 관심 카테고리에 포함된 crossTip 카테고리.
    private static func scoredCategories(
        of item: ChecklistItem,
        selectedCategories: [ChecklistCategory]
    ) -> [ChecklistCategory] {
        let categories = [item.basicCategory] + item.crossTip.keys
        return categories.filter { category in
            let isSelectableBasicCategory = item.basicCategory == category && category.isSelectable
            return selectedCategories.contains(category) || isSelectableBasicCategory
        }
    }
}
