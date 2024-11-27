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
    
    enum Checklist {
        static let bottomButton = "집 구조 스캔하기"
        static let navigationTitle = "주인님을 위한\n맞춤 체크리스트예요"
        static let memoSectionTitle = "메모"
        static let memoPlaceHolder = "메모를 입력해 주세요"
    }
    
    enum MainView {
        static let navigationTitleText: String = "어떤 집을 \n보러 갈까요?"
        static let homeHuntButtonMain: String = "집 보러가기"
        static let homeHuntButtonSub: String = "용북이와 함께 집을 둘러보아요"
        static let viewedHomeButton: String = "내가 본 집"
        static let recentlyViewedHomeTitle: String = "최근 본 집"
        static let recentlyViewedHomeContent: String = "아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요."
            
        
    }
    
    enum APIEndpoints {
        static let baseURL: String = "https://maps.googleapis.com/maps/api"

        case nearbySearch(latitude: Double, longitude: Double, radius: Int, keyword: String, apiKey: String)
        case autoComplete(query: String, apiKey: String)
        case placeDetails(placeID: String, apiKey: String)
        case reverseGeocode(latitude: Double, longitude: Double, apiKey: String)
        

        var url: String {
            switch self {
            case let .nearbySearch(latitude, longitude, radius, keyword, apiKey):
                return """
                \(APIEndpoints.baseURL)/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)
                """
            case .autoComplete(query: let query, apiKey: let apiKey):
                return """
                \(APIEndpoints.baseURL)/place/autocomplete/json?input=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(apiKey)
                """
            case .placeDetails(placeID: let placeID, apiKey: let apiKey):
                return """
                \(APIEndpoints.baseURL)/place/details/json?place_id=\(placeID)&key=\(apiKey)
                """
            case .reverseGeocode(latitude: let latitude, longitude: let longitude, apiKey: let apiKey):
                return """
                \(APIEndpoints.baseURL)/geocode/json?latlng=\(latitude),\(longitude)&key=\(apiKey)
                """
            }
        }
    }
}
