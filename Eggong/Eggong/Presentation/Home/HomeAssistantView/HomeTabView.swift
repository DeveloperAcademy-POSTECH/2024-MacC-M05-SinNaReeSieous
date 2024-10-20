//
//  HomeTabView.swift
//  Eggong
//
//  Created by JIN LEE on 10/20/24.
//

import SwiftUI

struct HomeTabView: View {
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        
        VStack {
            HStack {
                Button() {
                    selectedTab = .random
                } label: {
                    VStack {
                        Text("무작위")
                            .foregroundStyle(selectedTab == .random ? .orange : .gray)
                            .fontWeight(selectedTab == .random ? .heavy : .bold)
                            .font(selectedTab == .random ? .system(size: 16) : .system(size: 13))
                        Rectangle()
                            .fill(selectedTab == .random ? .orange : .gray)
                            .frame(width: 115, height: selectedTab == .random ? 4 : 2)
                        
                        
                    }
                }
                
                Button() {
                    selectedTab = .distance
                } label: {
                    VStack {
                        Text("거리순")
                            .foregroundStyle(selectedTab == .distance ? .orange : .gray)
                            .fontWeight(selectedTab == .distance ? .heavy : .bold)
                            .font(selectedTab == .distance ? .system(size: 16) : .system(size: 13))
                        Rectangle()
                            .fill(selectedTab == .distance ? .orange : .gray)
                            .frame(width: 115, height: selectedTab == .distance ? 4 : 2)
                    }
                }
                
                Button() {
                    selectedTab = .latest
                } label: {
                    VStack {
                        Text("최신순")
                            .foregroundStyle(selectedTab == .latest ? .orange : .gray)
                            .fontWeight(selectedTab == .latest ? .heavy : .bold)
                            .font(selectedTab == .latest ? .system(size: 16) : .system(size: 13))
                        Rectangle()
                            .fill(selectedTab == .latest ? .orange : .gray)
                            .frame(width: 115, height: selectedTab == .latest ? 4 : 2)
                    }
                }
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(selectedTab: .constant(.random))
    }
}

//#Preview {
//    HomeTabView
//}
