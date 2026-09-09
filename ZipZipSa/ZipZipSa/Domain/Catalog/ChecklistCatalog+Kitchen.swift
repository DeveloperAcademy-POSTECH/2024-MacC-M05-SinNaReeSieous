//
//  ChecklistCatalog+Kitchen.swift
//  ZipZipSa
//
//  체크리스트 질문 카탈로그 — 주방 공간.
//  code는 영구 식별자다: 절대 변경/재사용하지 말고, 새 질문은 마지막 번호 뒤에 추가한다.
//

import Foundation

extension ChecklistItem {
    static let kitchenItems: [ChecklistItem] = [
        
        ChecklistItem(
            legacyID: 36,
            code: "kit-01",
            space: Space(type: .kitchen,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "부엌에 환기를 위한 창문이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 37,
            code: "kit-02",
            space: Space(type: .kitchen,
                         questionNumber: 2),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "주방 후드 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 38,
            code: "kit-03",
            space: Space(type: .kitchen,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "찬장 안이나 냉장고 아래에 전 세입자가 치우지 않은 음식물이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "후드 위 찬장과 같은 곳도 꼭 확인하세요. 썩은 음식물 때문에 벌레가 꼬일 수 있어요."
        ),
        ChecklistItem(
            legacyID: 39,
            code: "kit-04",
            space: Space(type: .kitchen,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "찬장의 경첩부분에 검은색 작은 점 같은 흔적이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "바퀴벌레 배설물일 가능성이 있어요.",
            hazard: .cockroach
        ),
        ChecklistItem(
            legacyID: 30,
            code: "kit-05",
            space: Space(type: .kitchen,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화구의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 41,
            code: "kit-06",
            space: Space(type: .kitchen,
                         questionNumber: 6),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "싱크대의 수압은 강한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["약해요", "보통이에요", "강해요"]),
            hazard: .waterPressure
        ),
        ChecklistItem(
            legacyID: 42,
            code: "kit-07",
            space: Space(type: .kitchen,
                         questionNumber: 7),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "온수가 나오는 데 얼마나 걸리나요?",
                               answerType: .multiChoices,
                               answerOptions: ["느려요", "보통이에요", "빨라요"]),
            hazard: .waterCold
        ),
        ChecklistItem(
            legacyID: 43,
            code: "kit-08",
            space: Space(type: .kitchen,
                         questionNumber: 8),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "싱크대의 배수가 잘되나요?",
                               answerType: .multiChoices,
                               answerOptions: ["안 돼요", "보통이에요", "잘 돼요"]),
            hazard: .waterDrainage
        ),
        ChecklistItem(
            legacyID: 44,
            code: "kit-09",
            space: Space(type: .kitchen,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "싱크대 개수구에서 불쾌한 냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"])
        ),
        ChecklistItem(
            legacyID: 45,
            code: "kit-10",
            space: Space(type: .kitchen,
                         questionNumber: 10),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "하부장 안쪽 배수관에 누수의 흔적이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "하부장 바닥이 축축하거나 울어 있는지 확인해 보세요. 심한 경우 아랫집 천장에 누수를 일으킬 수 있어요.",
            hazard: .waterLeak
        ),
        ChecklistItem(
            legacyID: 46,
            code: "kit-11",
            space: Space(type: .kitchen,
                         questionNumber: 11),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "냉장고 내부에서 냄새가 나거나 얼룩이 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
    ]
}
