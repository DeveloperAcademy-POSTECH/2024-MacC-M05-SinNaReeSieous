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
    @State private var homeList: [ViewedHome] = []  // 데이터 모델을 위한 배열
    
    @State private var showHomeHuntSheet = false
    @State private var showHomeResultCardSheet = false
    @State private var selectedHome: HomeData = HomeData()
    
    var body: some View {
        ZStack{
            Color.Background.primary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopBar
                if homeList.isEmpty {
                    Spacer().frame(height: UIScreen.screenSize.height/812*48)
                    NoHome
                } else {
                    ScrollView {
                        ViewedHomeList
                            .padding(.horizontal, 16)
                    }
                    .contentMargins(.bottom, 24, for: .automatic)
                    .scrollIndicators(.hidden)
                }
            }
            .sheet(isPresented: $showHomeResultCardSheet, content: {
                ResultCardSheetView(homeData: $selectedHome)
                    .presentationDragIndicator(.visible)
            })
        }
        .accentColor(Color.Button.tertiary)
        .fullScreenCover(isPresented: $showHomeHuntSheet) {
            EssentialInfoView(showHomeHuntSheet: $showHomeHuntSheet)
        }
        .onAppear {
            homeList = homes.map {
                return ViewedHome(
                    id: $0.id,
                    image: $0.homeImage,
                    title: $0.homeName,
                    address: $0.locationText,
                    rentType: $0.homeCategoryType?.text)
            }
        }
        .onChange(of: showHomeResultCardSheet) { oldValue, newValue in
            if !showHomeResultCardSheet {
                homeList = homes.map {
                    return ViewedHome(
                        id: $0.id,
                        image: $0.homeImage,
                        title: $0.homeName,
                        address: $0.locationText,
                        rentType: $0.homeCategoryType?.text)
                }
            }
        }
        .onChange(of: homes) { oldValue, newValue in
            homeList = homes.map {
                return ViewedHome(
                    id: $0.id,
                    image: $0.homeImage,
                    title: $0.homeName,
                    address: $0.locationText,
                    rentType: $0.homeRentalType?.text)
            }
        }
    }
}

private extension HomeListView {
    
    var NoHome: some View {
        VStack {
            NoHomeImage
            NoHomeText
            Spacer().frame(height: UIScreen.screenSize.height/812*168)
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
            ForEach(Array(homeList.reversed().enumerated()), id: \.element.id) { index, home in
                Button {
                    if let selectedHomeIndex = homes.firstIndex(where: {$0.id == home.id }) {
                        self.selectedHome = homes[selectedHomeIndex]
                        showHomeResultCardSheet = true
                        print(selectedHomeIndex)
                        print(homes[selectedHomeIndex].homeName)
                    }
                } label: {
                    ViewedHomeCellView(home: $homeList[homeList.count - 1 - index])
                }
            }
        }
        .padding(.top, 24)
    }
}

#Preview {
    HomeListView()
}
