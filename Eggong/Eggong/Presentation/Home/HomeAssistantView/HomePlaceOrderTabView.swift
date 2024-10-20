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
        VStack {
            HStack(alignment: .bottom) {
                tabButton(tab: .random, text: "무작위")
                tabButton(tab: .distance, text: "거리순")
                tabButton(tab: .latest, text: "최신순")
            }
        }
    }
}
    
    private extension HomePlaceOrderTabView {
        
    func tabButton(tab: Tab, text: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                Text(text)
                    .foregroundStyle(selectedTab == tab ? .orange : .gray)
                    .fontWeight(selectedTab == tab ? .heavy : .bold)
                    .font(selectedTab == tab ? .system(size: 16) : .system(size: 13))
                Rectangle()
                    .fill(selectedTab == tab ? .orange : .gray)
                    .frame(width: 115, height: selectedTab == tab ? 4 : 2)
            }
        }
    }
}
