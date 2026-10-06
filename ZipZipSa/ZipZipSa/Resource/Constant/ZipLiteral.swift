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
            "주인님만의 체크리스트를 만들 수 있어요. \n집 볼 때 꼭 확인하고 싶은 항목을 \n직접 추가해 보세요!",
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
        static let checklistManageButtonMain: String = "체크리스트 관리"
        static let checklistManageButtonSub: String = "목록을 만들고 수정해요"
        static let homeHuntButtonMain: String = "집 보러가기"
        static let homeHuntButtonSub: String = "용북이와 함께 집을 둘러봐요"
        static let recentlyViewedHomeTitle: String = "최근 본 집"
        static let seeAllViewedHomes: String = "전체보기"
        static let recentlyViewedHomeContent: String = "아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요."
    }

    enum FraudBook {
        static let navigationTitle: String = "용북이의\n전월세사기 도감"
        static let back: String = "뒤로"
        static let emptyContent: String = "아직 준비 중인 내용이에요.\n조금만 기다려 주세요."
    }

    enum Checklist {
        static let bottomButton = "집 구조 스캔하기"
        static let navigationTitle = "주인님을 위한\n맞춤 체크리스트예요"
        static let memoSectionTitle = "메모"
        static let memoPlaceHolder = "메모를 입력해 주세요"
    }

    enum ChecklistTemplate {
        // 관리(목록) 화면
        static let listTitle = "수정할 체크리스트를\n알려주세요"
        static let back = "뒤로"
        static let create = "만들기"
        static let defaultTemplateName = "기본"
        /// 관심 카테고리를 골라둔 기존 사용자의 세트를 옮겨 담은 템플릿 이름
        static let favoriteMigratedName = "카테고리 반영 체크리스트"
        static let primaryBadge = "대표"
        static let questionCountSuffix = "개 문항"
        static let setAsPrimary = "대표로 지정"
        static let delete = "삭제"

        // 템플릿 선택 화면
        static let presetSelectTitle = "질문 템플릿을 선택하여\n시작할 수 있어요"
        static let presetBasic = "기본"
        static let presetDetailed = "자세히보기"
        static let presetQuick = "빠르게보기"
        static let presetCustom = "직접 추가하기"

        // 편집 화면
        static let close = "닫기"
        static let editTitleSuffix = "체크리스트예요"
        static let newTemplateTitleName = "새로 만드는"
        static let addSectionTitle = "질문 추가하기"
        static let addAction = "추가하기"
        static let removeAction = "삭제하기"
        static let next = "다음"

        // 이름 입력 화면
        static let nameEditTitle = "변경할 체크리스트\n이름을 알려주세요"
        static let nameNewTitle = "새 체크리스트\n이름을 알려주세요"
        static let namePlaceholder = "이름을 입력해 주세요"
        static let setPrimaryCheckbox = "대표 체크리스트로 설정하기"
        static let complete = "완료하기"
        static let later = "나중에 할래요"

        // 체크리스트 전환 시트
        static let switchButton = "체크리스트 변경"
        static let switchTitle = "사용할 체크리스트를\n선택해 주세요"
        static let inUse = "사용 중"
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
        static let roomModelSectionEmptyText: String = "집 구조스캔을 하지 않았어요."
        static let nearbySectionTitle: String = "주변 시설"
        static let nearbySectionEmptyText: String = "이 집 주변에는 시설이 없어요."
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

        // 집 둘러보기 그만두기
        static let quitHomeHuntTitle: String = "집 둘러보기를 그만두시겠어요?"
        static let quitHomeHuntMessage: String = "저장하지 않은 내용은 모두 삭제됩니다."
        static let close: String = "닫기"

        // 체크리스트 편집 중 나가기
        static let discardTemplateEditTitle: String = "변경 내용을 저장하지 않고 나갈까요?"
        static let discardTemplateEditMessage: String = "저장되지 않은 수정 내용이 사라집니다."
        static let leave: String = "나가기"

        // 체크리스트 삭제
        static func deleteTemplateTitle(_ name: String) -> String {
            "'\(name)'\(objectParticle(after: name)) 삭제할까요?"
        }
        static let deleteTemplateMessage: String = "삭제할 경우 되돌릴 수 없습니다"
        static let delete: String = "삭제"

        // 기본 체크리스트는 삭제할 수 없다
        static let cannotDeleteDefaultTitle: String = "'기본 문항'은 삭제할 수 없어요."
        static let cannotDeleteDefaultMessage: String = "기본 문항은 삭제가 불가능합니다."

        // 대표로 지정된 체크리스트는 삭제할 수 없다
        static func cannotDeletePrimaryTitle(_ name: String) -> String {
            "'\(name)'\(topicParticle(after: name)) 삭제할 수 없어요."
        }
        static let cannotDeletePrimaryMessage: String = "대표 체크리스트는 삭제가 불가능합니다."

        /// 마지막 글자에 받침이 있는지. 판별할 수 없으면 nil.
        /// 체크리스트 이름은 사용자가 정하므로 "체크리스트을" 같은 문장이 나오지 않게 한다.
        /// 한글과 숫자만 판별한다.
        private static func hasFinalConsonant(_ word: String) -> Bool? {
            guard let last = word.last else { return nil }
            if let scalar = last.unicodeScalars.first?.value, (0xAC00...0xD7A3).contains(scalar) {
                return (scalar - 0xAC00) % 28 != 0
            }
            // 1(일)·3(삼)처럼 읽었을 때 받침이 있는 숫자
            if let digit = last.wholeNumberValue, (0...9).contains(digit) {
                return [0, 1, 3, 6, 7, 8].contains(digit)
            }
            return nil
        }

        /// 목적격 조사 (을/를)
        private static func objectParticle(after word: String) -> String {
            (hasFinalConsonant(word) ?? false) ? "을" : "를"
        }

        /// 주제 조사 (은/는)
        private static func topicParticle(after word: String) -> String {
            (hasFinalConsonant(word) ?? false) ? "은" : "는"
        }
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
