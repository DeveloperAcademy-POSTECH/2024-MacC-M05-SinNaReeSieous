//
//  ZipLiteral.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import Foundation

enum ZipLiteral {
    // MARK: - View
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
    
    enum CategorySelect{
        static let defaultMessage: String = "아래 카테고리에 해당하는 필수 질문은 이미 있어요. 중요하게 보고 싶은 카테고리를 선택하시면, 더 꼼꼼히 확인할 수 있도록 추가 질문도 챙겨드릴게요."
        static let requiredTime: String = "집보는 시간"
        static let done: String = "완료"
    }
    
    enum MainView {
        static let navigationTitleText: String = "어떤 집을 \n보러 갈까요?"
        static let homeHuntButtonMain: String = "집 보러가기"
        static let homeHuntButtonSub: String = "용북이와 함께 집을 둘러보아요"
        static let viewedHomeButton: String = "내가 본 집"
        static let recentlyViewedHomeTitle: String = "최근 본 집"
        static let recentlyViewedHomeContent: String = "아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요."
    }
    
    enum Checklist {
        static let bottomButton = "집 구조 스캔하기"
        static let navigationTitle = "주인님을 위한\n맞춤 체크리스트예요"
        static let memoSectionTitle = "메모"
        static let memoPlaceHolder = "메모를 입력해 주세요"
    }
    
    enum UnsupportedDevice {
        static let title: String =
        """
        집 구조 기록을
        지원하지 않는 기기예요
        """
        static let description: String =
        """
        RoomPlan 기능은 LiDAR 센서가 있는
        iPhone 12 시리즈 이상의
        Pro 및 Pro Max 모델에서만 지원합니다.
        
        바로 결과지를 보러 가볼까요?
        """
        static let showResult: String = "결과지 보기"
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
    
    enum ResultCard{
        // ResultCardView
        static let navigationTitleText: String = "집 요약 카드예요"
        static let resultDetailButtonText: String = "상세보기"
        static let sharePreviewText: String = "집 요약 카드 공유"
        static let sharePreviewIcon: String = "AppIcon"
        static let shareButtonText: String = "공유하기"
        
        // ShareCardView
        static let categorySectionTitle: String = "카테고리"
        static let hazardSectionTitle: String = "주의 요소"
        static let hazardSectioinEmptyText: String = "우와, 여기는 안전한 곳이에요!"
        static let roomModelSectionTitle: String = "집 구조"
        static let roomModelSectionEmptyText: String = "집 구조 등록으로 내게 꼭 맞는 집을\n더 쉽게 찾아보세요"
        static let nearbySectionTitle: String = "주변 시설"
        static let nearbySectionEmptyText: String = "이 집 주변에는 시설이 없어요"
    }
    
    enum HomeList{
        static let myViewedHome: String = "내가 본 집"
        static let noViewedHome: String = "아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요."
        static let goHomeHuntWithYongboogi: String = "용북이와 함께 집 보러 가기"
    }
    
    enum Setting{
        static let setting: String = "설정"
        static let categoryChange: String = "카테고리"
        static let termsOfUse: String = "이용약관"
        static let privacyPolicy: String = "개인정보 처리방침"
        static let support: String = "지원"
    }
    
    // MARK: - etc.
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
