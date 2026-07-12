//
//  ChecklistCatalog+LivingRoom.swift
//  ZipZipSa
//
//  체크리스트 질문 카탈로그 — 거실 및 현관 공간.
//  code는 영구 식별자다: 절대 변경/재사용하지 말고, 새 질문은 마지막 번호 뒤에 추가한다.
//

import Foundation

extension ChecklistItem {
    static let livingRoomItems: [ChecklistItem] = [
        
        ChecklistItem(
            legacyID: 10,
            code: "lvr-01",
            space: Space(type: .livingRoom,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "복도의 소리가 집 안에서 잘 들리나요?",
                               answerType: .multiChoices,
                               answerOptions: ["잘 들려요", "보통이에요", "안 들려요"])
        ),
        ChecklistItem(
            legacyID: 11,
            code: "lvr-02",
            space: Space(type: .livingRoom,
                         questionNumber: 2),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "이중 잠금장치 혹은 보안장치가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 12,
            code: "lvr-03",
            space: Space(type: .livingRoom,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "집 현관에 도어락이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 13,
            code: "lvr-04",
            space: Space(type: .livingRoom,
                         questionNumber: 4),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "인터폰 화면으로 바깥을 볼 수 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            legacyID: 14,
            code: "lvr-05",
            space: Space(type: .livingRoom,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "가구 옵션을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["침대", "책상", "옷장", "신발장"])
        ),
        ChecklistItem(
            legacyID: 15,
            code: "lvr-06",
            space: Space(type: .livingRoom,
                         questionNumber: 6),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "가전 옵션을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["세탁기", "냉장고", "가스레인지", "하이라이트", "에어컨", "전자레인지", "TV", "인터넷"])
        ),
        ChecklistItem(
            legacyID: 16,
            code: "lvr-07",
            space: Space(type: .livingRoom,
                         questionNumber: 7),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "주택용 화재경보기 및 소화기가 비치되어 있나요?",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["주택용 화재경보기", "소화기"]),
            remark: "주택용 화재경보기 및 소화기 비치는 선택이 아니라 의무에요! 없을 경우 집주인에게 요청할 수 있어요."
        ),
        ChecklistItem(
            legacyID: 17,
            code: "lvr-08",
            space: Space(type: .livingRoom,
                         questionNumber: 8),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "오래된 목재 가구가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "먼지 다듬이나 권연벌레가 살기 좋은 환경이에요."
        ),
        ChecklistItem(
            legacyID: 18,
            code: "lvr-09",
            space: Space(type: .livingRoom,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "옵션 가구의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 19,
            code: "lvr-10",
            space: Space(type: .livingRoom,
                         questionNumber: 10),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "에어컨에 누수 흔적이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            hazard: .waterLeak
        ),
        ChecklistItem(
            legacyID: 20,
            code: "lvr-11",
            space: Space(type: .livingRoom,
                         questionNumber: 11),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "에어컨을 작동시켰을 때 냄새가 나지않고 내부가 깨끗한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 21,
            code: "lvr-12",
            space: Space(type: .livingRoom,
                         questionNumber: 12),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "거실 전등에 벌레 사체가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"])
        ),
        ChecklistItem(
            legacyID: 22,
            code: "lvr-13",
            space: Space(type: .livingRoom,
                         questionNumber: 13),
            checkListType: .basic,
            basicCategory: .sunlight,
            question: Question(question: "낮 시간에 불을 끄고도 실내가 충분히 밝게 느껴지나요?",
                               answerType: .multiChoices,
                               answerOptions: ["어두워요", "보통이에요", "밝아요"])
        ),
        ChecklistItem(
            legacyID: 23,
            code: "lvr-14",
            space: Space(type: .livingRoom,
                         questionNumber: 14),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "위층에서 발소리나 생활소음이 들리나요?",
                               answerType: .multiChoices,
                               answerOptions: ["잘 들려요", "보통이에요", "안 들려요"]),
            hazard: .noise
        ),
        ChecklistItem(
            legacyID: 24,
            code: "lvr-15",
            space: Space(type: .livingRoom,
                         questionNumber: 15),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "옆집과 닿아있는 벽의 종류가 어떻게 되나요?",
                               answerType:.twoChoices,
                               answerOptions: ["가벽", "콘크리트벽"]),
            remark: "두드렸을 때 텅텅 울리는 소리가 나면 가벽이에요.",
            hazard: .noise
        ),
        ChecklistItem(
            legacyID: 25,
            code: "lvr-16",
            space: Space(type: .livingRoom,
                         questionNumber: 16),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "벽지의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 26,
            code: "lvr-17",
            space: Space(type: .livingRoom,
                         questionNumber: 17),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "벽 모서리나 구석에 검은색 작은 점 같은 흔적이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "바퀴벌레 배설물일 가능성이 있어요.",
            hazard: .cockroach
        ),
        ChecklistItem(
            legacyID: 27,
            code: "lvr-18",
            space: Space(type: .livingRoom,
                         questionNumber: 18),
            checkListType: .basic,
            basicCategory: .environment,
            question: Question(question: "벽에 곰팡이가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [.sunlight: "햇빛이 잘 들어오면 벽에 곰팡이가 생길 가능성이 적어요." ,
                       .ventilation: "환기가 잘 되면 벽에 곰팡이가 생길 가능성이 적어요.",
                       .cleanliness: "습기가 많이 생기는 창틀 근처나 옆집 화장실이 닿아있는 쪽 벽을 살펴보세요."],
            remark: nil,
            hazard: .mold
        ),
        ChecklistItem(
            legacyID: 28,
            code: "lvr-19",
            space: Space(type: .livingRoom,
                         questionNumber: 19),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "바닥 틈새에 이물질이 없고 깨끗한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            legacyID: 29,
            code: "lvr-20",
            space: Space(type: .livingRoom,
                         questionNumber: 20),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "집에 간장냄새와 같은 달큰한 냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"]),
            remark: "바퀴벌레가 있는 집에서 이런 냄새가 날 수 있어요.",
            hazard: .cockroach
        ),
        ChecklistItem(
            legacyID: 30,
            code: "lvr-21",
            space: Space(type: .livingRoom,
                         questionNumber: 21),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "세탁기 고무패킹이나 세제통의 청결상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
    ]
}
