//
//  ZipZipSaTip.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/23/24.
//

import Foundation

struct ZipZipSaTip {
    static let tips = [
        "입주하기 2주 전에는 꼭 도시가스 신청을 하세요! \n도시가스 신청은 하루만에 안될 가능성이 높아요. 입주날에 호달달 떨면서 자고싶지 않다면 꼭 신청하세요~",
        "인터넷이나 TV 같은 통신 서비스는 입주 전에 이전 신청을 해 두는 것이 좋습니다. 특히 이사철에는 설치 대기가 길어질 수 있어요.",
        "이사를 한 날에는 전입신고를 잊지 마세요! 전입신고를 하지 않으면, 보증금을 돌려받는 순위가 밀리는 등의 불이익이 발생할 수 있어요.",
        "아파트나 오피스텔 등에서 입주 전 사전 점검 날짜가 있다면 꼭 참여하세요. 문, 창문, 전기, 수도 등 문제가 있을 경우 입주 전에 해결할 수 있습니다.",
        "입주 전에 입주청소를 예약하거나 직접 청소할 여유 시간을 생각해두세요.",
        "이사 당일 필요한 물건(예: 청소 용품, 휴지, 물)은 별도로 챙겨두세요. 이사 후 짐 정리가 되기 전까지 사용할 기본 물품들이 필요할 수 있습니다.",
        "이사 당일에 사용할 주차 공간을 미리 확인하세요. 짐 옮길 때 편리하게 주차할 수 있도록 미리 협의해두면 수월합니다."
    ]
    
    static private var displayedTips: [String] = []
      
      static func getRandomText() -> String {
          if displayedTips.isEmpty {
              displayedTips = tips.shuffled()
          }
          return displayedTips.removeFirst()
      }
}
