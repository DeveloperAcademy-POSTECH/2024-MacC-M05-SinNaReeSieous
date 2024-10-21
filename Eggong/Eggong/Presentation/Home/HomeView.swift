//
//  HomeView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showSheet: SheetType?
    @State var selectedTab: Tab = .random
    
    var body: some View {
        NavigationStack {
            HomePlaceOrderTabView(selectedTab: $selectedTab)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CurrentLocationView
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        ToolbarButtonView
                    }
                }
                .accentColor(.black)
                .sheet(item: $showSheet) { sheetType in
                    SheetView(type: sheetType, showSheet: $showSheet)
                }
        }
    }
}

private extension HomeView {
    
    var CurrentLocationView: some View {
        Text("효곡동")
            .fontWeight(.heavy)
            .font(.system(size: 22))
    }
    
    var ToolbarButtonView: some View {
        HStack {
            toolbarButton(systemName: "bookmark.fill", action: { showSheet = .bookmark })
            toolbarButton(systemName: "person.circle.fill", action: { showSheet = .myPage })
        }
    }
    
    private func toolbarButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    HomeView()
}
