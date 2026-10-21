//
//  HomeListView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/27/24.
//

import SwiftUI
import SwiftData

struct HomeListView: View {
    @Query var homes: [HomeData]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedHome: HomeData = HomeData()
    @State private var showHomeHuntSheet = false
    @State private var showHomeResultCardSheet = false
    
    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if homes.isEmpty {
                    TopBar
                    Spacer().frame(height: UIScreen.screenSize.height/812*48)
                    NoHome
                } else {
                    // 타이틀도 목록과 함께 스크롤되고, 고정되는 건 뒤로 버튼이 있는 바뿐이다
                    ScrollView {
                        VStack(spacing: 0) {
                            TopBar
                            ViewedHomeList
                                .padding(.horizontal, 16)
                        }
                    }
                    .contentMargins(.bottom, 24, for: .automatic)
                    .scrollIndicators(.hidden)
                }
            }
            
        }
        .accentColor(Color.Button.tertiary)
        .sheet(isPresented: $showHomeResultCardSheet) {
            ResultCardSheetView(homeData: $selectedHome)
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showHomeHuntSheet) {
            HomeHuntSheetView(showHomeHuntSheet: $showHomeHuntSheet)
        }
    }
}

private extension HomeListView {
    
    var NoHome: some View {
        VStack {
            NoHomeImage
            NoHomeText
            Spacer()
            GoHomeHuntButton
        }
    }
    
    var TopBar: some View {
        HStack {
            Text(ZipLiteral.HomeList.myViewedHome)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.leading, 16)
        // 상단 버튼과 타이틀 사이 간격은 전월세사기 도감과 같게(위 12) 맞춘다
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
    
    var NoHomeImage: some View {
        Image("cryingYongboogiSquareColor")
            .padding(.top, 60)
    }
    
    var NoHomeText: some View {
        Text(ZipLiteral.HomeList.noViewedHome)
            .foregroundStyle(Color.Text.tertiary)
            .multilineTextAlignment(.center)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.top, 29)
    }
    
    var GoHomeHuntButton: some View {
        Button{
            showHomeHuntSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Button.primaryBlue)
                .frame(width:UIScreen.screenSize.width - 32, height: 53)
                .overlay {
                    Text(ZipLiteral.HomeList.goHomeHuntWithYongboogi)
                        .applyZZSFont(zzsFontSet:.bodyBold)
                        .foregroundStyle(Color.Text.primary)
                }
        }
        .padding(.bottom, 12)
    }
    
    var ViewedHomeList: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 32) {
            ForEach(Array(homes.reversed().enumerated()), id: \.element.id) { index, home in
                Button {
                    if let selectedHomeIndex = homes.firstIndex(where: {$0.id == home.id }) {
                        self.selectedHome = homes[selectedHomeIndex]
                        showHomeResultCardSheet = true
                    }
                } label: {
                    ViewedHomeCellView(home: home)
                }
                .contextMenu {
                    DeleteButton(homeData: home)
                }
            }
        }
        .padding(.top, 24)
    }
    
    private func DeleteButton(homeData: HomeData) -> some View {
        Button(role: .destructive){
            deleteHome(homeData)
        } label: {
            Label("삭제", systemImage: "trash")
                .font(.subheadline)
        }
    }
    
    private func deleteHome(_ homeData: HomeData) {
        withAnimation {
            modelContext.delete(homeData)
        }
    }
}

#Preview {
    HomeListView()
}
