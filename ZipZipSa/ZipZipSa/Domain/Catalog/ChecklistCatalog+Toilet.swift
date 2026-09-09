//
//  ChecklistCatalog+Toilet.swift
//  ZipZipSa
//
//  체크리스트 질문 카탈로그 — 화장실 공간.
//  code는 영구 식별자다: 절대 변경/재사용하지 말고, 새 질문은 마지막 번호 뒤에 추가한다.
//

import Foundation

extension ChecklistItem {
    static let toiletItems: [ChecklistItem] = [
        
        ChecklistItem(
            legacyID: 47,
            code: "toi-01",
            space: Space(type: .toilet,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화장실에서 담배냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"]),
            hazard: .cigaretteSmell
        ),
        ChecklistItem(
            legacyID: 48,
            code: "toi-02",
            space: Space(type: .toilet,
                         questionNumber: 2),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화장실 하수구에서 불쾌한 냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"])
        ),
        ChecklistItem(
            legacyID: 49,
            code: "toi-03",
            space: Space(type: .toilet,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "화장실에 환기를 위한 창문이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 50,
            code: "toi-04",
            space: Space(type: .toilet,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "화장실에 환기구(환풍기)가 설치되어 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 51,
            code: "toi-05",
            space: Space(type: .toilet,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "변기와 샤워기, 수도 등의 수압은 강한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["약해요", "보통이에요", "강해요"]),
            hazard: .waterPressure
        ),
        ChecklistItem(
            legacyID: 52,
            code: "toi-06",
            space: Space(type: .toilet,
                         questionNumber: 6),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "온수가 나오는 데 얼마나 걸리나요?",
                               answerType: .multiChoices,
                               answerOptions: ["느려요", "보통이에요", "빨라요"]),
            hazard: .waterCold
        ),
        ChecklistItem(
            legacyID: 53,
            code: "toi-07",
            space: Space(type: .toilet,
                         questionNumber: 7),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "세면대, 샤워실의 배수가 잘 되나요?",
                               answerType: .multiChoices,
                               answerOptions: ["안 돼요", "보통이에요", "잘 돼요"]),
            hazard: .waterDrainage
        ),
        ChecklistItem(
            legacyID: 54,
            code: "toi-08",
            space: Space(type: .toilet,
                         questionNumber: 8),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화장실 실리콘에 검은색 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 55,
            code: "toi-09",
            space: Space(type: .toilet,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "세면대 아래쪽이나 뒤쪽에 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 56,
            code: "toi-10",
            space: Space(type: .toilet,
                         questionNumber: 10),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "변기 물탱크에 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
    ]
}
