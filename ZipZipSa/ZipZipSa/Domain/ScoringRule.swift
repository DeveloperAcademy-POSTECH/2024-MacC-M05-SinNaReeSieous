//
//  ScoringRule.swift
//  ZipZipSa
//

import Foundation

/// 질문 하나의 점수 규칙을 데이터로 표현한다.
/// 기존에는 이 상수들이 답변 버튼 액션과 집계 함수 곳곳에 흩어져 있었다.
/// 규칙이 데이터가 되면 커스텀 체크리스트에서 질문 조합이 바뀌어도
/// 점수·만점 계산이 자동으로 따라온다.
struct ScoringRule: Hashable {
    /// 단일 선택형: 선택 인덱스별 점수 (twoChoices는 [0, 2], multiChoices는 [0, 1, 2]).
    /// 복수 선택형(multiSelect)은 nil.
    let optionScores: [Float]?

    /// 복수 선택형의 기본 점수 (미응답·0개 선택 시의 시작점).
    let baseScore: Float

    /// 복수 선택형의 선택 1개당 가감점 (부정 성향 -0.5, 그 외 +0.5).
    let perSelection: Float

    /// 미응답 질문이 카테고리 집계에 가산되는 기본값.
    let unansweredScore: Float

    /// 만점 집계에 가산되는 값.
    /// 주의: 중립(neutral) 성향 multiSelect는 기존 로직상 만점에 아무것도 더하지 않는다(0).
    let maxScore: Float
}

extension ChecklistItem {
    /// 답변 타입에서 파생되는 점수 규칙.
    /// 기존 3곳에 흩어져 있던 상수(2점/인덱스점수/±0.5/basicScore/만점 2.0)를 그대로 담았다.
    var scoringRule: ScoringRule {
        switch question.answerType {
        case .twoChoices:
            return ScoringRule(
                optionScores: [0, 2],
                baseScore: 0,
                perSelection: 0,
                unansweredScore: 1.0,
                maxScore: 2.0
            )
        case .multiChoices:
            return ScoringRule(
                optionScores: question.answerOptions.indices.map(Float.init),
                baseScore: 0,
                perSelection: 0,
                unansweredScore: 1.0,
                maxScore: 2.0
            )
        case .multiSelect(let basicScore, let answerDisposition):
            let perSelection: Float = answerDisposition == .negative ? -0.5 : 0.5
            let maxScore: Float
            switch answerDisposition {
            case .negative:
                maxScore = basicScore
            case .positive:
                maxScore = Float(question.answerOptions.count) * 0.5
            case .neutral:
                maxScore = 0
            }
            return ScoringRule(
                optionScores: nil,
                baseScore: basicScore,
                perSelection: perSelection,
                unansweredScore: basicScore,
                maxScore: maxScore
            )
        }
    }
}
