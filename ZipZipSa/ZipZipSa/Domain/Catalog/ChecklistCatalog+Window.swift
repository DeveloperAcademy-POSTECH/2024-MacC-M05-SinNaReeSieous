//
//  ChecklistCatalog+Window.swift
//  ZipZipSa
//
//  체크리스트 질문 카탈로그 — 창문 공간.
//  code는 영구 식별자다: 절대 변경/재사용하지 말고, 새 질문은 마지막 번호 뒤에 추가한다.
//

import Foundation

extension ChecklistItem {
    static let windowItems: [ChecklistItem] = [
        
        ChecklistItem(
            legacyID: 31,
            code: "win-01",
            space: Space(type: .window,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .sunlight,
            question: Question(question: "창문의 크기는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["작아요", "보통이에요", "커요"]),
            crossTip: [.ventilation: "창문의 크기가 크면 환기와 채광이 좋을 수 있어 곰팡이 위험이 줄어들어요."]
        ),
        ChecklistItem(
            legacyID: 32,
            code: "win-02",
            space: Space(type: .window,
                         questionNumber: 2),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "서로 다른 벽에 창문이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"]),
            remark: "창문이 마주보고 있거나 ‘ㄱ’자로 있으면 맞바람이 불어서 환기가 잘 돼요."
        ),
        ChecklistItem(
            legacyID: 33,
            code: "win-03",
            space: Space(type: .window,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "저층의 집을 보고 있는 경우, 창문에 방범창이 달려 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["없어요", "해당사항 없음", "있어요"])
        ),
        ChecklistItem(
            legacyID: 34,
            code: "win-04",
            space: Space(type: .window,
                         questionNumber: 4),
            checkListType: .quick,
            basicCategory: .sunlight,
            question: Question(question: "집과 앞 건물 사이의 거리는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["가까워요", "보통이에요", "멀어요"]),
            crossTip: [.ventilation: "집 앞 건물과 너무 가까우면 햇빛과 바람이 잘 들지 않고, 사생활 보호가 어려울 수 있어요.",
                       .security: "집 앞 건물과 너무 가까우면 햇빛과 바람이 잘 들지 않고, 사생활 보호가 어려울 수 있어요."],
            hazards: [.privacy]
        ),
        ChecklistItem(
            legacyID: 35,
            code: "win-05",
            space: Space(type: .window,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "방충망에 찢어지거나 틈이 있는 곳이 없나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [.ventilation: "방충망이 찢어지거나 삭아 있는지 미리 확인하고, 날짜가 남도록 사진을 찍어두세요. 입주 전부터 있던 하자라는 증거가 없으면 퇴거할 때 원상복구 비용을 떠안을 수 있어요. 문제가 있다면 '입주 전 임대인이 수리 완료'를 계약서 특약으로 넣어두는 게 안전해요."]
        ),
        ChecklistItem(
            legacyID: 59,
            code: "win-06",
            space: Space(type: .window,
                         questionNumber: 6),
            checkListType: .advanced,
            basicCategory: .environment,
            question: Question(question: "창문이 이중창인가요?",
                               answerType: .twoChoices,
                               answerOptions: ["단창", "이중창"]),
            remark: "단창은 열 손실이 크고, 결로 때문에 곰팡이가 생기기 쉬워요.",
            hazards: [.noise, .mold]
        ),
    ]
}
