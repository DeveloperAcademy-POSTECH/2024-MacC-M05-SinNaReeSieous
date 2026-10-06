//
//  ChecklistCategory.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum ChecklistCategory: String, CaseIterable, Hashable {
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
        case .facilities: return "공용시설 및 옵션"
        }
    }
    
    var isSelectable: Bool {
        switch self {
        case .insectproof, .cleanliness, .security, .ventilation, .sunlight, .soundproof: return true
        case .environment, .facilities: return false
        }
    }

    /// 결과 카드의 점수 그래프 표시 순서.
    static let resultCardOrder: [ChecklistCategory] = [
        .insectproof, .cleanliness, .security, .ventilation, .soundproof, .sunlight
    ]
}

// MARK: - 온보딩/설정 카테고리 선택 화면용 메타데이터
// (기존 OnboardingCategory 구조체를 흡수 — 카테고리 정의가 두 곳으로 갈라지지 않게 한다)

extension ChecklistCategory {
    struct SelectionMeta {
        let onImage: String
        let offImage: String
        /// 이 카테고리를 선택하면 체크리스트 소요 시간이 몇 분 늘어나는지
        let requiredTime: Int
        let message: String
    }

    /// 선택 화면 노출 순서 (isSelectable한 6종).
    static let selectionOrder: [ChecklistCategory] = [
        .insectproof, .cleanliness, .security, .ventilation, .soundproof, .sunlight
    ]

    /// 선택 가능 카테고리의 화면 메타데이터. environment/facilities는 nil.
    var selectionMeta: SelectionMeta? {
        switch self {
        case .insectproof:
            return SelectionMeta(
                onImage: "InsectProofColor",
                offImage: "InsectProofSepia",
                requiredTime: 1,
                message: "해충 흔적과 방충 시설 상태를 더 꼼꼼히 볼 수 있도록 질문을 추가해둘게요."
            )
        case .cleanliness:
            return SelectionMeta(
                onImage: "CleanlinessColor",
                offImage: "CleanlinessSepia",
                requiredTime: 2,
                message: "집 안에서 놓치기 쉬운 곳까지 구석구석 살펴볼 수 있도록 질문을 추가해둘게요."
            )
        case .security:
            return SelectionMeta(
                onImage: "SecurityColor",
                offImage: "SecuritySepia",
                requiredTime: 1,
                message: "보안 장치, 주변 환경, 시설까지 꼼꼼히 살필 수 있게 질문을 추가해둘게요."
            )
        case .ventilation:
            return SelectionMeta(
                onImage: "VentilationColor",
                offImage: "VentilationSepia",
                requiredTime: 1,
                message: "집이 환기하기에 좋은 상태인지 알 수 있도록 체크 포인트를 알려드릴게요!"
            )
        case .soundproof:
            return SelectionMeta(
                onImage: "SoundproofColor",
                offImage: "SoundproofSepia",
                requiredTime: 1,
                message: "이 집이 소음, 방음 측면에서 어떤지 더 꼼꼼히 알 수 있도록 질문을 추가해둘게요."
            )
        case .sunlight:
            return SelectionMeta(
                onImage: "LightedColor",
                offImage: "LightedSepia",
                requiredTime: 1,
                message: "집 안에 빛이 잘 들어오는지 좀 더 꼼꼼히 체크할 수 있도록 할게요."
            )
        case .environment, .facilities:
            return nil
        }
    }
}
