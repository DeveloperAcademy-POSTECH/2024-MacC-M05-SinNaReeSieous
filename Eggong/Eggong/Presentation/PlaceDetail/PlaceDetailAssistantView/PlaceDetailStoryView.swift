//
//  PlaceDetailStoryView.swift
//  Eggong
//
//  Created by 조우현 on 10/19/24.
//

import SwiftUI

struct PlaceDetailStoryView: View {
    var selectedIndex: Int
    
    var body: some View {
        ZStack {
            if selectedIndex == 0 {
                Text("지난달에는 고려대 학생들과 협업해 아침밥 사업을 기획하고 진행했어요. 등교하는 학생들, 출근하는 직원들, 그리고 고생한다며 따뜻한 인사를 건네주시는 어르신들 덕분에 마음이 참 따뜻해졌답니다. 여섯 시부터 출근하느라 피곤했지만, 그만큼 보람도 크게 느꼈어요.")
            } else if selectedIndex == 1 {
                Text("리브랜딩을 위해 새벽까지 이어지는 메뉴 개발 현장입니다. 휙의 시그니처 메뉴들은 긴 시간에 걸쳐 내부 회의와 수많은 시음을 거쳐 손님들께 선보이게 됩니다. 한층 더 완성도 높은 메뉴를 위해 팀원들은 끊임없는 논의와 테스트를 반복하며 최선을 다하고 있습니다.")
            } else if selectedIndex == 2 {
                Text("최근에는 시립대 관현악 동아리와 협업해 특별한 클래식 공연을 열었습니다. 이번엔시립대 학생들뿐만 아니라 동네 주민분들도 함께 찾아주셔서 모두가 한데 어우러져 클래식의 매력을 만끽한 멋진 경험이었어요. 지역 사회와 더 가까워질 수 있는 뜻깊은 시간이었습니다.")
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: selectedIndex)
        .padding(16)
    }
}

#Preview {
    PlaceDetailStoryView(selectedIndex: 0)
}
