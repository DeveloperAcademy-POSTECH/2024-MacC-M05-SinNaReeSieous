//
//  Category.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/28/24.
//

import Foundation

struct OnboardingCategory {
    
    let checklistCategory: ChecklistCategory
    let onImage: String
    let offImage: String
    let requiredTime: Int
    let categoryMessage: String
}

extension OnboardingCategory {
    static let categories: [OnboardingCategory] = [
        OnboardingCategory(
            checklistCategory: .insectproof,
            onImage: "InsectProofColor",
            offImage: "InsectProofSepia",
            requiredTime: 3,
            categoryMessage: "해충 흔적과 방충 시설 상태를 더 꼼꼼히 볼 수 있도록 질문을 추가해둘게요."
        ),
        OnboardingCategory(
            checklistCategory: .cleanliness,
            onImage: "CleanlinessColor",
            offImage: "CleanlinessSepia",
            requiredTime: 3,
            categoryMessage: "집 안에서 놓치기 쉬운 곳까지 구석구석 살펴볼 수 있도록 질문을 추가해둘게요."
        ),
        OnboardingCategory(
            checklistCategory: .security,
            onImage: "SecurityColor",
            offImage: "SecuritySepia",
            requiredTime: 3,
            categoryMessage: "보안 장치, 주변 환경, 시설까지 꼼꼼히 살필 수 있게 질문을 추가해둘게요."
        ),
        OnboardingCategory(
            checklistCategory: .ventilation,
            onImage: "VentilationColor",
            offImage: "VentilationSepia",
            requiredTime: 3,
            categoryMessage: "집이 환기하기에 좋은 상태인지 알 수 있도록 체크 포인트를 알려드릴게요!"
        ),
        OnboardingCategory(
            checklistCategory: .soundproof,
            onImage: "SoundproofColor",
            offImage: "SoundproofSepia",
            requiredTime: 3,
            categoryMessage: "이 집이 소음, 방음 측면에서 어떤지 더 꼼꼼히 알 수 있도록 질문을 추가해둘게요."
        ),
        OnboardingCategory(
            checklistCategory: .sunlight,
            onImage: "LightedColor",
            offImage: "LightedSepia",
            requiredTime: 3,
            categoryMessage: "집 안에 빛이 잘 들어오는지 좀 더 꼼꼼히 체크할 수 있도록 할게요.")
    ]
}
