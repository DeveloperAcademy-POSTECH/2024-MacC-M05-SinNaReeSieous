//
//  ChecklistItem.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/18/24.
//

import Foundation

struct ChecklistItem: Identifiable, Hashable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    let space: Space
    let checkListType: ChecklistType
    let basicCategory: ChecklistCategory
    let question: Question
    let crossTip: [ChecklistCategory: String]
    let remark: String?
    let hazard: Hazard?
    
    init(space: Space,
         checkListType: ChecklistType,
         basicCategory: ChecklistCategory,
         question: Question,
         crossTip: [ChecklistCategory : String] = [:],
         remark: String? = nil,
         hazard: Hazard? = nil
    ) {
        self.id = UUID()
        self.space = space
        self.checkListType = checkListType
        self.basicCategory = basicCategory
        self.question = question
        self.crossTip = crossTip
        self.remark = remark
        self.hazard = hazard
    }
}

extension ChecklistItem {
    static let checklistItems = [
        
        // ============================ 외부 ============================ //
        
        ChecklistItem(
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
            space: Space(type: .exterior,
                         questionNumber: 6),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "쓰레기 처리장이 청결하게 관리되고있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
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
            space: Space(type: .exterior,
                         questionNumber: 8),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "공동현관에 잠금장치가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .exterior,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "CCTV가 있는 곳을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .positive),
                               answerOptions: ["건물 입구", "복도", "계단", "주차장", "건물 밖"])
        ),
        ChecklistItem(
            space: Space(type: .exterior,
                         questionNumber: 10),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "건물 옵션을 선택해주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["택배보관함", "집주인 거주", "반려동물 가능", "소화전", "엘리베이터", "주차 가능"])
        ),
        
        // ======================== 거실 및 현관 ============================ //
        
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "복도의 소리가 집 안에서 잘 들리나요?",
                               answerType: .multiChoices,
                               answerOptions: ["잘 들려요", "보통이에요", "안 들려요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 2),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "이중 잠금장치 혹은 보안장치가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "집 현관에 도어락이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 4),
            checkListType: .advanced,
            basicCategory: .security,
            question: Question(question: "인터폰 화면으로 바깥을 볼 수 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "가구 옵션을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["침대", "책상", "옷장", "신발장"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 6),
            checkListType: .basic,
            basicCategory: .facilities,
            question: Question(question: "가전 옵션을 선택해 주세요.",
                               answerType: .multiSelect(basicScore: 0, answerDisposition: .neutral),
                               answerOptions: ["세탁기", "냉장고", "가스레인지", "하이라이트", "에어컨", "전자레인지", "TV", "인터넷"])
        ),
        ChecklistItem(
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
            space: Space(type: .livingRoom,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "옵션 가구의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
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
            space: Space(type: .livingRoom,
                         questionNumber: 11),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "에어컨을 작동시켰을 때 냄새가 나지않고 내부가 깨끗한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 12),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "거실 전등에 벌레 사체가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"])
        ),
        ChecklistItem(
            space: Space(type: .livingRoom,
                         questionNumber: 13),
            checkListType: .basic,
            basicCategory: .sunlight,
            question: Question(question: "낮 시간에 불을 끄고도 실내가 충분히 밝게 느껴지나요?",
                               answerType: .multiChoices,
                               answerOptions: ["어두워요", "보통이에요", "밝아요"])
        ),
        ChecklistItem(
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
            space: Space(type: .livingRoom,
                         questionNumber: 16),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "벽지의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
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
            space: Space(type: .livingRoom,
                         questionNumber: 19),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "바닥 틈새에 이물질이 없고 깨끗한가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
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
            space: Space(type: .livingRoom,
                         questionNumber: 21),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "세탁기 고무패킹이나 세제통의 청결상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        
         // ======================== 창문 ============================ //
        
        ChecklistItem(
            space: Space(type: .window,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .sunlight,
            question: Question(question: "창문의 크기는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["작아요", "보통이에요", "커요"]),
            crossTip: [.ventilation: "환기가 잘 되면 습기가 차지 않아 곰팡이가 없어요."]
        ),
        ChecklistItem(
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
            space: Space(type: .window,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .security,
            question: Question(question: "저층의 집을 보고 있는 경우, 창문에 방범창이 달려 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["없어요", "해당사항 없음", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .window,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .sunlight,
            question: Question(question: "집과 앞 건물 사이의 거리는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["가까워요", "보통이에요", "멀어요"]),
            crossTip: [.ventilation: "앞 집과 거리가 너무 가까우면 바람이 잘 통하지 않아요.",
                       .security: "집 앞 건물과 너무 가까우면 사생활 보호가 되지 않을 수 있어요."],
            hazard: .privacy
        ),
        ChecklistItem(
            space: Space(type: .window,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "방충망에 찢어지거나 틈이 있는 곳이 없나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [.ventilation: "방충망이 찢어져있다면 환기가 불편할 수 있어요."]
        ),
        
        // ======================== 주방 ============================ //
        
        ChecklistItem(
            space: Space(type: .kitchen,
                         questionNumber: 1),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "부엌에 환기를 위한 창문이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .kitchen,
                         questionNumber: 2),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "주방 후드 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            space: Space(type: .kitchen,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .insectproof,
            question: Question(question: "찬장 안이나 냉장고 아래에 전 세입자가 치우지 않은 음식물이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            remark: "후드 위 찬장과 같은 곳도 꼭 확인하세요."
        ),
        ChecklistItem(
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
            space: Space(type: .kitchen,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화구의 상태는 어떤가요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
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
            space: Space(type: .kitchen,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "싱크대 개수구에서 불쾌한 냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"])
        ),
        ChecklistItem(
            space: Space(type: .kitchen,
                         questionNumber: 10),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "하부장 안쪽 배수관에 누수의 흔적이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            hazard: .waterLeak
        ),
        ChecklistItem(
            space: Space(type: .kitchen,
                         questionNumber: 11),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "냉장고 내부에서 냄새가 나거나 얼룩이 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        
        // ======================== 화장실 ============================ //
        
        ChecklistItem(
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
            space: Space(type: .toilet,
                         questionNumber: 2),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화장실 하수구에서 불쾌한 냄새가 나나요?",
                               answerType: .twoChoices,
                               answerOptions: ["나요", "안 나요"])
        ),
        ChecklistItem(
            space: Space(type: .toilet,
                         questionNumber: 3),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "화장실에 환기를 위한 창문이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
            space: Space(type: .toilet,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .ventilation,
            question: Question(question: "화장실에 환기구(환풍기)가 설치되어 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["없어요", "있어요"])
        ),
        ChecklistItem(
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
            space: Space(type: .toilet,
                         questionNumber: 8),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "화장실 실리콘에 검은색 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            space: Space(type: .toilet,
                         questionNumber: 9),
            checkListType: .basic,
            basicCategory: .cleanliness,
            question: Question(question: "세면대 아래쪽이나 뒤쪽에 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        ),
        ChecklistItem(
            space: Space(type: .toilet,
                         questionNumber: 10),
            checkListType: .advanced,
            basicCategory: .cleanliness,
            question: Question(question: "변기 물탱크에 곰팡이가 있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"])
        )
    ]
}



