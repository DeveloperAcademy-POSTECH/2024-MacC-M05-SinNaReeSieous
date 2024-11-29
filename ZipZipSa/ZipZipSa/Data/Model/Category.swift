//
//  Category.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/28/24.
//

import Foundation

struct Category {
    
    let categoryElement: String
    let onImage: String
    let offImage: String
    let requiredTime: Int
    let categoryMessage: String
}

extension Category {
    static let categories: [Category] = [
        Category(categoryElement: "InsectProof", onImage: "InsectProofColor", offImage: "InsectProofSepia", requiredTime: 3, categoryMessage: "해충 흔적과 방충 시설 상태를 더 꼼꼼히 볼 수 있도록 질문을 추가해둘게요."),
        Category(categoryElement: "Cleenliness", onImage: "CleanlinessColor", offImage: "CleanlinessSepia", requiredTime: 3, categoryMessage: "집 안에서 놓치기 쉬운 곳까지 구석구석 살펴볼 수 있도록 질문을 추가해둘게요."),
        Category(categoryElement: "Security", onImage: "SecurityColor", offImage: "SecuritySepia", requiredTime: 3, categoryMessage: "보안 장치, 주변 환경, 시설까지 꼼꼼히 살필 수 있게 질문을 추가해둘게요."),
        Category(categoryElement: "Ventilation", onImage: "VentilationColor", offImage: "VentilationSepia", requiredTime: 3, categoryMessage: "집이 환기하기에 좋은 상태인지 알 수 있도록 체크 포인트를 알려드릴게요!"),
        Category(categoryElement: "Soundproof", onImage: "SoundproofColor", offImage: "SoundproofSepia", requiredTime: 3, categoryMessage: "이 집이 소음, 방음 측면에서 어떤지 더 꼼꼼히 알 수 있도록 질문을 추가해둘게요."),
        Category(categoryElement: "Lighted", onImage: "LightedColor", offImage: "LightedSepia", requiredTime: 3, categoryMessage: "집 안에 빛이 잘 들어오는지 좀 더 꼼꼼히 체크할 수 있도록 할게요.")
    ]
}
