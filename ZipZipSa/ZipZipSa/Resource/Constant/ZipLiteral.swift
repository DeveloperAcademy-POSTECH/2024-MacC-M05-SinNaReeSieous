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
    
    enum PrivacyPolicy {
        static let privacyPolicy: String = "개인정보 처리방침"
        static let textBody0: String = "“집집사”(이하 “앱”)는 이용자의 개인정보를 소중히 여기며, 「개인정보 보호법」 및 관련 법령을 준수하여 개인정보를 안전하게 관리하고 보호하기 위해 노력하고 있습니다. 본 방침은 이용자가 앱을 이용할 때 제공하는 개인정보가 어떻게 수집, 이용, 보관, 보호되는지에 대한 내용을 안내합니다."
        static let textTitle1: String = "1. 개인정보의 수집 항목 및 수집 방법"
        static let textBody1: String = "앱은 이용자에게 맞춤형 체크리스트 제공 및 서비스 향상을 위해 최소한의 개인정보를 수집합니다.\n•    수집 항목: 이메일 주소, 이름(선택 사항), 사용자가 선택한 체크리스트 항목\n•    수집 방법: 회원가입 시 사용자가 직접 입력, 앱 사용 과정에서 자동으로 생성되는 정보(사용 로그)"
        static let textTitle2: String = "2. 개인정보의 수집 및 이용 목적"
        static let textBody2: String = "수집된 개인정보는 다음의 목적으로 사용됩니다.\n•    체크리스트 생성 및 저장 서비스 제공\n•    사용자 맞춤형 서비스 및 정보 제공\n•    고객 문의 및 불만 처리\n•    서비스 개선 및 사용자 경험 분석"
        static let textTitle3: String = "3. 개인정보 보관 및 이용 기간"
        static let textBody3: String = "앱은 개인정보 보유 기간을 관련 법령에서 정한 기준에 따라 관리하며, 보관 기간이 지난 개인정보는 즉시 파기합니다.\n•    회원 정보: 회원 탈퇴 시 즉시 삭제\n•    서비스 이용 기록: 서비스 종료 후 1년간 보관 후 삭제"
        static let textTitle4: String = "4. 개인정보의 제3자 제공"
        static let textBody4: String = "앱은 이용자의 사전 동의 없이 개인정보를 제3자에게 제공하지 않습니다. 다만, 법령에 의해 요구되는 경우에는 예외로 합니다."
        static let textTitle5: String = "5. 개인정보 보호를 위한 기술적·관리적 조치"
        static let textBody5: String = "앱은 이용자의 개인정보를 보호하기 위해 다음과 같은 조치를 취하고 있습니다.\n•    개인정보 암호화 및 안전한 저장\n•    접근 권한 통제를 통한 보안 강화\n•    개인정보 관리 담당자의 교육 및 내부 관리 체계 구축"
        static let textTitle6: String = "6. 이용자의 권리"
        static let textBody6: String = "이용자는 언제든지 본인의 개인정보에 대한 열람, 수정, 삭제, 처리 정지를 요청할 수 있습니다. 요청은 앱 내 고객센터 또는 개인정보 보호 책임자를 통해 접수하며, 신속히 처리됩니다."
        static let textTitle7: String = "7. 개인정보 보호 책임자 및 문의처"
        static let textBody7: String = "앱은 개인정보 보호와 관련된 사항을 처리하기 위해 아래와 같이 개인정보 보호 책임자를 지정하고 있습니다. 귀하께서는 회사의 서비스를 이용하시며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당 부서로 신고하실 수 있습니다. 회사는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다\n•    책임자: 배희정\n•    연락처: TeamSNRSs@gmail.com\n•    고객센터: 앱 내 지원 페이지 이용"
        static let textTitle8: String = "8. 개인정보 처리방침 변경"
        static let textBody8: String = "본 개인정보처리방침은 각 국가별로 법률의 요구사항에 따라 언어별로 상이할 수 있습니다. 각 언어별 개인정보처리방침의 내용이 서로 충돌하는 경우에는 그 지역의 언어로 작성된 개인정보처리방침이 우선 적용되며, 그 지역의 언어로 작성된 개인정보처리방침이 없을 경우에는 영어로 작성된 개인정보처리방침이 적용됩니다. 한국어로 작성된 개인정보처리방침은 대한민국에서만 적용됩니다."
        static let textTitle9: String = "부칙"
        static let textBody9: String = "본 개인정보 처리방침은 법령 변경 또는 서비스 정책에 따라 수정될 수 있으며, 변경 시 앱 내 공지사항을 통해 사전에 안내합니다.\n•    시행일: 2024.12.12"
        static let textTitle10: String = "프리텐다드 라이센스 본문"
        static let textBody10: String = "https://noonnu.cc/font_page/694"
        
        
        
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
