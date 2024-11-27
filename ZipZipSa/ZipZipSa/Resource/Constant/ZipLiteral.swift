//
//  ZipLiteral.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import Foundation

enum ZipLiteral {
    enum RoomScan {
        static let doneSacnText: String = 
        """
        집의 구조를 한 눈에 볼 수 있도록
        각도를 조절해주세요.
        """
        static let cancle: String = "그만두기"
        static let done: String = "완료하기"
        static let reScasn: String = "다시찍기"
        static let save: String = "저장하기"
        static let processing: String = "저장 중..."
    }
    
    enum RoomScanInfo {
        static let title: String = "집 구조만 기록해요"
        static let description: String =
        """
        아이폰 내장 기술인 RoomPlan을 사용해
        집의 구조를 기록할 거예요.
        
        3d 모델 형태로 집 구조가 제공되며,
        이 과정에서 사진 정보는 기록되지 않아요.
        """
        static let start: String = "시작하기"
        static let skip: String = "건너뛰기"
    }
    
    enum UnsupportedDevice {
        static let title: String =
        """
        집 구조 기록을
        지원하지 않는 기기예요
        """
        static let description: String =
        """
        현재 RoomPlan 기능은
        iPhone Pro 및 Pro Max 모델에서만 지원합니다.
        
        바로 결과지를 보러 가볼까요?
        """
        static let showResult: String = "결과지 보기"
    }
    
    enum Alert {
        static let skipAlertTitle: String = "집 구조 기록 건너뛰기"
        static let skipAlertMessage: String =
        """
        구조 기록을 하지않고
        바로 결과지 화면으로 넘어갑니다.
        """
        static let quitAlertTitle: String = "집 구조 기록 그만두기"
        static let quitAlertMessage: String =
        """
        지금까지 저장된
        스캔 데이터가 삭제됩니다.
        """
        static let cancel: String = "취소"
        static let skip: String = "건너뛰기"
        static let quit: String = "그만두기"
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
