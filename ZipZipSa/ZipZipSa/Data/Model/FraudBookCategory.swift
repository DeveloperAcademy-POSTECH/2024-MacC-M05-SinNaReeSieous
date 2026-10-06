//
//  FraudBookCategory.swift
//  ZipZipSa
//

import Foundation

/// 전월세사기 도감의 아코디언 한 항목
struct FraudBookSection: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

/// 전월세사기 도감 카테고리 (Figma: 집집사_Hi-Fi_Copy 노드 5081-7502)
enum FraudBookCategory: Int, CaseIterable, Identifiable {
    case firstCheck
    case landlordHistory
    case depositSafety
    case afterContract
    case whileLiving

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .firstCheck: return "0. 가장 먼저 확인할 것"
        case .landlordHistory: return "1. 집주인의 이력 확인하기"
        case .depositSafety: return "2. 내 보증금 안전성 확인하기"
        case .afterContract: return "3. 계약 직후 해야할 것"
        case .whileLiving: return "4. 거주하며 해야할 것"
        }
    }

    var subtitle: String {
        switch self {
        case .firstCheck:
            return "집을 구할 때 가장 먼저\n확인 해야하는 내용을 담았어요."
        case .landlordHistory:
            return "공동담보가 되어있는지\n상습 체납자 명단에는 없는지 확인해요"
        case .depositSafety:
            return "보증금을 돌려받을 수 있는지\n확인해요"
        case .afterContract:
            return "계약 했다고 끝이 아니에요\n내 보증금을 안전하게 돌려받기 위해\n해야 할 것을 확인해요"
        case .whileLiving:
            return "내 보증금을 안전하게 돌려받기 위해\n해야 할 것을 확인해요"
        }
    }

    // TODO: 1~4번 카테고리는 Figma의 전용 캐릭터 에셋이 추가되면 교체
    var characterImage: String {
        switch self {
        case .firstCheck: return "writingYongboogiFullColor"
        case .landlordHistory: return "smileYongboogiFullColor"
        case .depositSafety: return "winkingYongboogiFullColor"
        case .afterContract: return "helloYongboogiFullColor"
        case .whileLiving: return "basicYongboogiBowtieHeadColor"
        }
    }

    // TODO: 0번은 Figma(노드 5086-6225) 내용으로 교체, 나머지 카테고리는 내용 확정 후 추가
    var sections: [FraudBookSection] {
        switch self {
        case .firstCheck:
            return [
                FraudBookSection(
                    title: "첫 번째 항목 제목",
                    content: "여기에 내용이 들어갈 예정이에요."
                ),
                FraudBookSection(
                    title: "두 번째 항목 제목",
                    content: "여기에 내용이 들어갈 예정이에요."
                ),
                FraudBookSection(
                    title: "세 번째 항목 제목",
                    content: "여기에 내용이 들어갈 예정이에요."
                )
            ]
        case .landlordHistory, .depositSafety, .afterContract, .whileLiving:
            return []
        }
    }
}
