//
//  ChecklistCatalog+Exterior.swift
//  ZipZipSa
//
//  체크리스트 질문 카탈로그 — 외부 공간.
//  code는 영구 식별자다: 절대 변경/재사용하지 말고, 새 질문은 마지막 번호 뒤에 추가한다.
//

import Foundation

extension ChecklistItem {
    static let exteriorItems: [ChecklistItem] = [
        
        ChecklistItem(
            legacyID: 0,
            code: "ext-01",
            space: Space(type: .exterior,
                         questionNumber: 1),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "집 주변에 24시 편의점이나 마트가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"]),
            crossTip: [:],
            remark: "밤 늦게 귀가 시 길이 더 밝고, 긴급한 경우 도움을 요청할 수 있어요.",
            hazard: nil
        ),
        ChecklistItem(
            legacyID: 1,
            code: "ext-02",
            space: Space(type: .exterior,
                         questionNumber: 2),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "집 주변에 가로등이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"]),
            crossTip: [:],
            remark: nil,
            hazard: nil
        ),
        ChecklistItem(
            legacyID: 2,
            code: "ext-03",
            space: Space(type: .exterior,
                         questionNumber: 3),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "집 주변에 산이나 숲이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "지네, 모기, 돈벌레 등이 나올 확률이 높아요."
        ),
        ChecklistItem(
            legacyID: 3,
            code: "ext-04",
            space: Space(type: .exterior,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "주변에 소음이 발생할 수 있는 시설이 있나요?",
                               answerType: .multiSelect(basicScore: 2.0, answerDisposition: .negative),
                               answerOptions: ["유흥가", "학교", "공원", "상가"]),
            crossTip: [.security: "유흥가가 집 근처에 있으면 주취자를 마추질 가능성이 높아져요."]
        ),
        ChecklistItem(
            legacyID: 4,
            code: "ext-05",
            space: Space(type: .exterior,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "집 앞에 큰 도로가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [.ventilation: "매연 때문에 환기하기 어려울 수 있어요."]
        ),
        ChecklistItem(
            legacyID: 5,
            code: "ext-06",
            space: Space(type: .exterior,
                         questionNumber: 6),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "쓰레기 처리장이 청결하게 관리되고있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"]),
            crossTip: [.insectproof : "쓰레기 처리장에서 발생한 벌레가 집으로 들어올 수 있어요."]
        ),
        ChecklistItem(
            legacyID: 6,
            code: "ext-07",
            space: Space(type: .exterior,
                         questionNumber: 7),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "해당 건물에 식당이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "식당 근처에는 벌레가 서식할 가능성이 높아요."
        ),
        ChecklistItem(
            legacyID: 7,
            code: "ext-08",
            space: Space(type: .exterior,
                         questionNumber: 8),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "공동현관에 잠금장치가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 8,
            code: "ext-09",
            space: Space(type: .exterior,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "CCTV가 있는 곳을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .positive),
                               answerOptions: ["건물 입구", "복도", "계단", "주차장", "건물 밖"])
        ),
        ChecklistItem(
            legacyID: 9,
            code: "ext-10",
            space: Space(type: .exterior,
                         questionNumber: 10),
            checkListType: .quick,
            basicCategory: .facilities,
            question: Question(question: "건물 옵션을 선택해주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["택배보관함", "집주인 거주", "반려동물 가능", "소화전", "엘리베이터", "주차 가능"])
        ),
    ]
}
