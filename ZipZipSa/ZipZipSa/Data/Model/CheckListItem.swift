//
//  CheckListItem.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/18/24.
//

// 체크리스트 기본 카테고리, 추가 카테고리 어떻게 구분할지?
// 선호장르 선택하면, 질문들을 어떻게 불러올지 고민하면서 카테고리 형태를 만들어 보자!!!!!!!!!!!!!! 이게 제일 중요. 계속 이 부분을 생각하자.
// category, checkListType이 두 정보를 하나의 구조체에 담아서 묶어도 좋을 것 같기도 하고..
// 크로스 질문 팁도 결국 카테고리에 의존한다. 이 정보들을 하나로 통합할 수 없을지 고민해보자.
// 답변 기록 형태 및, 결과지를 위해 어떤 정보가 필요한지 까지 같이 고민할 것 !

import Foundation

struct CheckListItem: Identifiable {
    var id: UUID = UUID()
    let space: Space
    let checkListType: CheckListType
    let basicCategory: CheckListCategory
    let question: Question
    let crossTip: [CheckListCategory: String]
    let remark: String?
    let hazard: Hazard?
}

extension CheckListItem {
    static let CheckListItems = [
        CheckListItem(
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
        CheckListItem(
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
        CheckListItem(
            space: Space(type: .exterior,
                         questionNumber: 3),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "집 주변에 산이나 숲이 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [:],
            remark: "지네, 모기, 돈벌레 등이 나올 확률이 높아요.",
            hazard: nil
        ),
        CheckListItem(
            space: Space(type: .exterior,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "주변에 소음이 발생할 수 있는 시설이 있나요?",
                               answerType: .multiSelect(basicScore: 1.0),
                               answerOptions: ["유흥가", "학교", "공원", "상가"]),
            crossTip: [.security: "유흥가가 집 근처에 있으면 주취자를 마추질 가능성이 높아져요."],
            remark: nil,
            hazard: nil
        ),
        CheckListItem(
            space: Space(type: .exterior,
                         questionNumber: 5),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "집 앞에 큰 도로가 있나요?",
                               answerType: .twoChoices,
                               answerOptions: ["있어요", "없어요"]),
            crossTip: [.ventilation: "매연 때문에 환기하기 어려울 수 있어요."],
            remark: nil,
            hazard: nil
        ),
        CheckListItem(
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
            hazard: nil
        )
    ]
}

let answers: [UUID: [Int]] = [:]
let scores: [UUID: Int] = [:]

enum Hazard {
    case waterLeak
    case waterPressure
    case waterCold
    case waterDrainage
    case mold
    case noise
    case privacy
    case cockroach
    
    var text: String {
        switch self {
        case .waterLeak: return "누수위험"
        case .waterPressure: return "수압위험"
        case .waterCold: return "온수위험"
        case .waterDrainage: return "배수위험"
        case .mold: return "곰팡이위험"
        case .noise: return "소음위험"
        case .privacy: return "사생활위험"
        case .cockroach: return "바퀴위험"
        }
    }
}

struct Question {
    let question: String
    let answerType: AnswerType
    let answerOptions: [String]
}

enum AnswerType: Equatable {
    case twoChoices
    case multiChoices
    case multiSelect(basicScore: Float)
}

enum CheckListType {
    case basic
    case advanced
    
    var text: String {
        switch self {
        case .basic: "기본"
        case .advanced: "추가"
        }
    }
}

enum CheckListCategory: Hashable {
    case insectproof
    case cleanliness
    case security
    case ventilation
    case sunlight
    case soundproof
    case environment
    case facilities
    
    var text: String {
        switch self {
        case .insectproof: return "방충"
        case .cleanliness: return "청결"
        case .security: return "치안"
        case .ventilation: return "환기"
        case .sunlight: return "채광"
        case .soundproof: return "방음"
        case .environment: return "실내환경"
        case .facilities: return "공용시설 및 음선"
        }
    }
    
    var isSelectable: Bool {
        switch self {
        case .insectproof, .cleanliness, .security, .ventilation, .sunlight, .soundproof: return true
        case .environment, .facilities: return false
        }
    }
}

enum SpaceType: CaseIterable {
    case exterior
    case livingRoom
    case window
    case kitchen
    case toilet
    
    var text: String {
        switch self {
        case .exterior: return "외부"
        case .livingRoom: return "거실 및 현관"
        case .window: return "창문"
        case .kitchen: return "주방"
        case .toilet: return "화장실"
        }
    }
}

struct Space {
    let type: SpaceType
    let questionNumber: Int
}

enum captionType {
    case remark
    case crossTip
    case none
}
