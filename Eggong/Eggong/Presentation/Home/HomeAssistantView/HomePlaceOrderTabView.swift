//
//  HomeTabView.swift
//  Eggong
//
//  Created by JIN LEE on 10/20/24.
//

import SwiftUI

struct HomePlaceOrderTabView: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
            HStack(spacing: 8) {
                tabButton(tab: .random, text: "무작위")
                tabButton(tab: .distance, text: "거리순")
                tabButton(tab: .latest, text: "최신순")
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
    }
}
    
    private extension HomePlaceOrderTabView {
        
    func tabButton(tab: Tab, text: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: selectedTab == tab ? 7 : 9) {
                Text(text)
                    .foregroundStyle(selectedTab == tab ? .accent : .gray60)
                    .font(selectedTab == tab ? .pretendard(size: 16, weight: .black) : .pretendard(size: 14, weight: .bold))
                Rectangle()
                    .fill(selectedTab == tab ? .accent : .gray60)
                    .frame(height: selectedTab == tab ? 4 : 2)
            }
        }
    }
}
