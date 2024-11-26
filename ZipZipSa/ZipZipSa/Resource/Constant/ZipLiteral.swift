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
    
    enum RoomScanInfo {
        static let infoTitle: String = "집 구조만 기록해요"
        static let infoDescription1: String = "아이폰 내장 기술인 RoomPlan을 사용해"
        static let infoDescription2: String = "집의 구조를 기록할 거예요."
        static let infoDescription3: String = "3d 모델 형태로 집 구조가 제공되며,"
        static let infoDescription4: String = "이 과정에서 사진 정보는 기록되지 않아요."
        static let start: String = "시작하기"
        static let skip: String = "건너뛰기"
        static let alertTitle: String = "집 구조 기록 건너뛰기"
        static let alertMessage: String = "구조 기록을 하지않고\n 바로 결과지 화면으로 넘어갑니다."
        static let cancel: String = "취소"
        static let confirm: String = "확인"
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
