//
//  ChecklistAnswerData.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// 질문 하나에 대한 답변 레코드 (스키마 V2).
/// V1의 answerData blob([Int: Set<Int>] JSON)을 정규화한 것.
/// 질문은 영구 code(String)로 식별한다 — 커스텀 체크리스트에서 질문 세트가
/// 사용자마다 달라져도 답변을 질문 단위로 안전하게 관리할 수 있다.
@Model
final class ChecklistAnswerData {
    var questionCode: String
    var selectedIndices: [Int]

    init(questionCode: String, selectedIndices: [Int]) {
        self.questionCode = questionCode
        self.selectedIndices = selectedIndices
    }
}

extension ChecklistAnswerData {
    var selection: Set<Int> {
        Set(selectedIndices)
    }
}
