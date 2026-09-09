//
//  ChecklistAnswerFixtures.swift
//  ZipZipSaTests
//

import Foundation
@testable import ZipZipSa

/// 점수 특성화(골든) 테스트용 고정 답변 세트.
/// 카탈로그를 순회해 결정적으로 생성하므로 질문이 추가/삭제되면 테스트가 함께 알아챈다.
/// Phase 1에서 ChecklistScoringService 추출 후, 이 픽스처로 계산한 카테고리 점수를
/// 리터럴로 고정해 리팩토링 전후 동작 불변을 보장한다.
enum ChecklistAnswerFixtures {

    /// 관심 카테고리 조합 픽스처
    static let noFavorites: [ChecklistCategory] = []
    static let twoFavorites: [ChecklistCategory] = [.security, .soundproof]
    static let allFavorites: [ChecklistCategory] = ChecklistCategory.allCases.filter(\.isSelectable)

    /// 모든 질문에 "첫 번째 옵션"으로 답한 세트.
    /// twoChoices/multiChoices는 [0], multiSelect는 {0} 선택.
    /// hazard 질문은 전부 위험 응답([0])이 되므로 hazard 수집 검증에도 쓰인다.
    static var allFirstOption: [String: Set<Int>] {
        var answers: [String: Set<Int>] = [:]
        for item in ChecklistItem.checklistItems {
            answers[item.code] = [0]
        }
        return answers
    }

    /// 모든 질문에 "마지막 옵션"으로 답한 세트.
    /// twoChoices는 긍정 응답(2점), multiSelect는 마지막 항목 1개 선택.
    static var allLastOption: [String: Set<Int>] {
        var answers: [String: Set<Int>] = [:]
        for item in ChecklistItem.checklistItems {
            answers[item.code] = [item.question.answerOptions.count - 1]
        }
        return answers
    }

    /// 짝수 legacyID 질문에만 첫 옵션으로 답하고 나머지는 미응답인 세트.
    /// 미응답 질문의 기본값 가산 규칙(multiSelect는 basicScore, 그 외 1.0)을 함께 검증한다.
    /// 주의: 선택 기준을 legacyID로 유지해야 Phase 1에서 고정한 골든 값이 유지된다.
    static var evenIdsFirstOption: [String: Set<Int>] {
        var answers: [String: Set<Int>] = [:]
        for item in ChecklistItem.checklistItems where item.legacyID.isMultiple(of: 2) {
            answers[item.code] = [0]
        }
        return answers
    }

    /// 전부 미응답.
    static let unanswered: [String: Set<Int>] = [:]

    /// multiSelect 질문만 모든 옵션을 선택한 세트 (개수 비례 점수 규칙 검증용).
    static var multiSelectAllOptions: [String: Set<Int>] {
        var answers: [String: Set<Int>] = [:]
        for item in ChecklistItem.checklistItems {
            if case .multiSelect = item.question.answerType {
                answers[item.code] = Set(item.question.answerOptions.indices)
            }
        }
        return answers
    }
}
