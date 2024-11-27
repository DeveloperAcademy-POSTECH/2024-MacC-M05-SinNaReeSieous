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
