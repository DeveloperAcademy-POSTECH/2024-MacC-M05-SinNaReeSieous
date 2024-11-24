//
//  ChecklistItem.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/18/24.
//

import Foundation

struct ChecklistItem: Identifiable {
    var id: UUID = UUID()
    let space: Space
    let checkListType: ChecklistType
    let basicCategory: ChecklistCategory
    let question: Question
    let crossTip: [ChecklistCategory: String]
    let remark: String?
    let hazard: Hazard?
}

extension ChecklistItem {
    static let checklistItems = [
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
            crossTip: [:],
            remark: "지네, 모기, 돈벌레 등이 나올 확률이 높아요.",
            hazard: nil
        ),
        ChecklistItem(
            space: Space(type: .exterior,
                         questionNumber: 4),
            checkListType: .basic,
            basicCategory: .soundproof,
            question: Question(question: "주변에 소음이 발생할 수 있는 시설이 있나요?",
                               answerType: .multiSelect(basicScore: 2.0, answerDisposition: .negative),
                               answerOptions: ["유흥가", "학교", "공원", "상가"]),
            crossTip: [.security: "유흥가가 집 근처에 있으면 주취자를 마추질 가능성이 높아져요."],
            remark: nil,
            hazard: nil
        ),
        ChecklistItem(
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
        ChecklistItem(
            space: Space(type: .exterior,
                         questionNumber: 6),
            checkListType: .advanced,
            basicCategory: .insectproof,
            question: Question(question: "쓰레기 처리장이 청결하게 관리되고있나요?",
                               answerType: .multiChoices,
                               answerOptions: ["더러워요", "보통이에요", "깨끗해요"]),
            crossTip: [:],
            remark: nil,
            hazard: nil
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
            hazard: nil
        )
    ]
}



