//
//  ZipLiteral.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import Foundation

enum ZipLiteral {
    enum RoomScan {
        static let doneSacnText: String = "집의 구조가 잘 보이게 3D 모델의 각도를 조절하세요."
        static let cancle: String = "그만두기"
        static let done: String = "완료하기"
        static let reScasn: String = "다시찍기"
        static let save: String = "저장하기"
        static let processing: String = "저장 중..."
    }
    
    enum MainView {
        static let navigationTitleText: String = "어떤 집을 \n보러 갈까요?"
        static let homeHuntButtonMain: String = "집 보러가기"
        static let homeHuntButtonSub: String = "용북이와 함께 집을 둘러보아요"
        static let viewedHomeButton: String = "내가 본 집"
        static let recentlyViewedHomeTitle: String = "최근 본 집"
        static let recentlyViewedHomeContent: String = "아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요."
            
        
    }
    
    enum Onboarding {
       static let onboardingGreetings = [
            "안녕하세요.\n저는 용궁에서 올라온 거북이, 용북이에요!",
            "저와 함께라면 빠르고 꼼꼼하게 \n집을 살펴볼 수 있어요.",
            "주인님이 집을 볼 때, 어디를 더 신경써서 \n보고싶은지 알려주세요. 주인님의 선호에 \n맞게 체크리스트를 준비할게요!",
            "그럼 바로 시작할까요?"
        ]
        static let startButtonText: String = "시작하기"
        static let continueButtonText: String = "계속하기"
    }
    
    enum APIEndpoints {
        static let baseURL: String = "https://maps.googleapis.com/maps/api"

        case nearbySearch(latitude: Double, longitude: Double, radius: Int, keyword: String, apiKey: String)

        var url: String {
            switch self {
            case let .nearbySearch(latitude, longitude, radius, keyword, apiKey):
                return """
                \(APIEndpoints.baseURL)/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)
                """
            }
        }
    }
}
