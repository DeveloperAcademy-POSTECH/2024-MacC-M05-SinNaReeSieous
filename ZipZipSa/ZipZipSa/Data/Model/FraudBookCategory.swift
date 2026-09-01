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

    var sections: [FraudBookSection] {
        switch self {
        case .firstCheck: return Self.firstCheckSections
        case .landlordHistory: return Self.landlordHistorySections
        case .depositSafety: return Self.depositSafetySections
        case .afterContract: return Self.afterContractSections
        case .whileLiving: return Self.whileLivingSections
        }
    }
}

// MARK: - 항목 내용

private extension FraudBookCategory {

    static var firstCheckSections: [FraudBookSection] {
        [
            FraudBookSection(
                title: "등기부등본 확인하기",
                content: "집의 소유자와 권리관계를 확인하는 가장 중요한 서류에요. 근저당, 가압류, 가처분 등 권리침해사항이 있다면 보증금을 돌려받기 어려워질 수 있기 때문에 인터넷등기소에서 꼭 발급받아봐야 해요."
            ),
            FraudBookSection(
                title: "건축물대장 확인하기",
                content: "위반건축물 여부를 확인해야 해요. 위반건축물이나 용도 불일치 건물은 보증보험 가입이 어렵기 때문에 꼭 정부24나 세움터에서 확인해야 해요."
            ),
            FraudBookSection(
                title: "실제 매물 존재 여부 확인하기",
                content: "주소가 정확한지, 지도와 로드뷰로 건물이 실제로 있는지를 확인해요. 허위, 미끼 매물을 거를 수 있어요."
            ),
            FraudBookSection(
                title: "부동산 앱으로 시세 비교하기",
                content: "요즘엔 부동산 시세를 알려주는 서비스들이 많아요. 이런 서비스들을 비교해가며 같은 동네, 비슷한 집의 시세를 확인해요. 유독 싸거나 비싸면 이유가 있는 경우가 많아요. “싼 데는 이유가 있다”는 것을 꼭! 기억하세요."
            ),
            FraudBookSection(
                title: "전세가율 확인하기",
                content: "매매가 대비 전세가 비율이 85% 이상이면 집값이 조금만 떨어져도 깡통전세가 될 수 있기 때문에 위험해요. 여러 부동산 플랫폼의 시세 기능으로 쉽게 비교할 수 있어요."
            ),
            FraudBookSection(
                title: "거래 이력 확인하기",
                content: "최근 실거래가가 있는지, 매물이 자주 올라갔다 내려갔는지 확인해야 해요. 짧은 기간에 반복 등록된 매물은 주의해야 해요."
            )
        ]
    }

    static var landlordHistorySections: [FraudBookSection] {
        [
            // TODO: 기획에서 상세 내용 확인 후 보강
            FraudBookSection(
                title: "등기부상 소유자와 동일 인물인지 확인하기",
                content: "계약 상대가 실제 집주인인지 꼭 확인해야 해요. 대리인 계약이면 위임장과 인감증명서가 필요해요. 이걸 피하려 한다면 의심해봐야 해요."
            ),
            FraudBookSection(
                title: "상습 보증금 체납 여부 확인하기",
                content: "HUG에서는 상습적으로 보증금을 체납한 이력이 있는 집주인을 알려줘요. HUG 사이트에서 집주인 이름만 검색하면 확인할 수 있고 상습 체납이력이 있다면 계약을 피하는 것이 좋아요."
            ),
            // TODO: 기획에서 상세 내용 추가되면 보강
            FraudBookSection(
                title: "다주택 임대인 여부 확인하기",
                content: "집을 여러 채 가진 집주인은 한꺼번에 대출을 많이 끼고 있는 경우가 있어, 동시 부도 위험이 커요. 특히 신축 빌라·오피스텔을 여러 채 보유한 경우 전세사기 사례가 많았으니, 등기부로 보유 현황을 꼭 확인하세요."
            ),
            FraudBookSection(
                title: "중개사와의 관계 확인하기",
                content: "중개사는 중립 의무가 있어요. 하지만 중개사가 집주인 편만 드는 느낌이라면 주의하고, 너무 불편하다면 다른 중개사를 찾아가도 돼요."
            )
        ]
    }

    static var depositSafetySections: [FraudBookSection] {
        [
            // TODO: 기획에서 상세 내용 수정되면 반영
            FraudBookSection(
                title: "보증보험 가입 가능 여부 확인하기",
                content: "HUG, SGI 보증보험 가입이 가능한지 확인해야 해요. 보증보험 각 상품마다 가입 가능 조건이 다르니, 내가 계약할 집에 가입할 수 있는 보증보험이 무엇인지 확인하고 보증금을 반환받지 못할 때를 대비해서 가입하도록 해요."
            ),
            FraudBookSection(
                title: "선순위 채권(근저당) 확인하기",
                content: "선순위 채권은 내 계약보다 먼저 설정된 빚이에요. 집이 경매에 넘어가면 1. 은행 대출(근저당), 2. 국가 세금(압류), 3. 세입자 보증금 순으로 나눠가지기 때문에 선순위 채권이 많을수록 내 보증금을 못 받을 가능성이 커요."
            ),
            FraudBookSection(
                title: "전세대출 가능 여부 확인하기",
                content: "은행대출이나 정부 전세대출이 가능한 집인지 확인해야 해요. 각 상품별로 조건이 다르기 때문에 계약할 집이 어떤 전세대출이 가능한지 확인해보는 것이 좋아요."
            ),
            FraudBookSection(
                title: "계약금 입금 계좌 확인하기",
                content: "집주인 명의 계좌로 입금해야 해요. 중개사 개인 계좌로 입금하는 것은 사기일 수 있기 때문에 조심하세요."
            ),
            FraudBookSection(
                title: "특약사항 확인하기",
                content: "근저당 추가 설정 금지, 보증금 반환 지연 책임 등 특약을 넣어야 해요. 계약서에 적혀있어야 효력이 있으니, 계약시 꼭 해당 내용을 넣어두세요."
            ),
            FraudBookSection(
                title: "계약서 내용 꼼꼼히 재확인하기",
                content: "사소한 오타 하나가 분쟁의 원인이 될 수 있기 때문에 주소, 보증금, 기간, 집주인 이름 등 꼼꼼히 확인하세요."
            )
        ]
    }

    static var afterContractSections: [FraudBookSection] {
        [
            FraudBookSection(
                title: "등기부등본 다시 발급받기",
                content: "계약 후 바로 등기부등본을 다시 한번 발급받아야 해요. 계약 직후 근저당을 거는 사기도 있기 때문에 변동이 있다면 계약 중단을 검토해보세요."
            ),
            FraudBookSection(
                title: "전입신고 하기",
                content: "전입신고를 해야 대항력이 생겨요. 정부24나 주민센터에서 가능하고 이사 당일에 바로 하는 것을 추천해요."
            ),
            FraudBookSection(
                title: "확정일자 받기",
                content: "확정일자는 보증금 우선순위를 지켜줘요. 전입신고 + 확정일자가 하나의 세트이기 때문에 같이 하는 것이 좋아요."
            ),
            FraudBookSection(
                title: "계약서, 서류 보관하기",
                content: "계약서 원본, 이체 내역 등 기록을 잘 보관해두세요. 분쟁 시 가장 중요한 증거가 될 수 있어요."
            ),
            FraudBookSection(
                title: "하자 상태 기록하기",
                content: "입주 직후 집 상태를 사진, 영상으로 남기세요. 나중에 보증금 공제 분쟁을 막을 수 있어요. 특히 벽지, 바닥, 가전의 상태는 꼭! 찍어두세요."
            )
        ]
    }

    static var whileLivingSections: [FraudBookSection] {
        [
            FraudBookSection(
                title: "주기적으로 등기부 확인하기",
                content: "집주인이 몰래 대출을 추가할 수도 있어, 등기부등본을 3~6개월에 한번 정도 확인해봐요. 인터넷등기소에서 쉽게 발급받을 수 있어요."
            ),
            FraudBookSection(
                title: "문제 발생 시 상담하기",
                content: "조금이라도 이상하면 혼자 버티지 말고 상담을 요청하세요. 전월세종합지원센터, 법률구조공단 등의 도움을 받을 수 있어요."
            )
        ]
    }
}
