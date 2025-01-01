//
//  MainView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Query var users: [User]
    @Query var homes: [HomeData]
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentTip = ZipZipSaTip.getRandomText()
    @State private var timer: Timer?
    @State private var showHomeHuntSheet: Bool = false
    @State private var showHomeResultCardSheet = false
    @State private var selectedHome: HomeData = HomeData()
    @State private var isDeleting: Bool = false
    @State private var deleteTargetHomeData: HomeData?
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.Background.primary
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0){
                    TopBar
                    ZipZipSaTips
                    MainButtons
                    RecentlyViewedHomeTitle
                    
                    if homes.isEmpty {
                        EmptyRecentlyViewedHome
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            RecentlyViewedHomeList
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .accentColor(Color.Button.tertiary)
        .navigationBarBackButtonHidden()
        .confirmationDialog("이 항목이 삭제됩니다.", isPresented: $isDeleting, titleVisibility: .visible) {
            Button("삭제", role: .destructive) {
                if let deleteTargetHomeData { modelContext.delete(deleteTargetHomeData)
                }
                isDeleting = false
                deleteTargetHomeData = nil
            }
        }
        .fullScreenCover(isPresented: $showHomeHuntSheet) {
            EssentialInfoView(showHomeHuntSheet: $showHomeHuntSheet)
        }
        .sheet(isPresented: $showHomeResultCardSheet, content: {
            ResultCardSheetView(homeData: $selectedHome)
                .presentationDragIndicator(.visible)
        })
        .onAppear {
            print(users.count)
            print(users.first?.favoriteCategories.map{$0.text})
            print(homes.count)
            print(homes.last?.homeName)
            print(users[0].favoriteCategories)
        }
        
    }
}

private extension MainView {
    
    var TopBar: some View {
        HStack (alignment: .top) {
            NavigationTitle
            Spacer()
            SettingButton
        }
        .padding(.top, 12)
        .padding(.bottom, 32)
        .padding(.horizontal, 16)
    }
    
    var NavigationTitle: some View {
        Text(ZipLiteral.MainView.navigationTitleText)
            .foregroundStyle(Color.Text.primary)
            .multilineTextAlignment(.leading)
            .lineLimit(2)  // nil 대신 2로 명시적 설정
            .fixedSize(horizontal: false, vertical: true)  // 세로 방향으로 필요한 만큼 공간 확보
            .applyZZSFont(zzsFontSet: .largeTitle)
    }
    
    var SettingButton: some View {
        NavigationLink(destination: SettingView()) {
            Image(systemName: "gearshape")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .iconLargeTitle)
        }
    }
    
    var ZipZipSaTips : some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(.black, lineWidth:1)
            .frame(height: 67)
            .overlay(alignment: .leading, content: {
                HStack(spacing: 12) {
                    Image("basicYongboogiHeadColor")
                        .resizable()
                        .frame(width: 36, height: 34)
                    Text(currentTip)
                        .applyZZSFont(zzsFontSet: .subheadlineRegular)
                        .lineLimit(3)
                        .transition(.slide)
                        .animation(.easeInOut, value: currentTip)
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
            })
            .padding(.horizontal, 16)
            .onAppear {
                // 기존 타이머가 있다면 무효화
                timer?.invalidate()
                // 텍스트 초기화
                currentTip = ZipZipSaTip.getRandomText()
                // 새로운 타이머 시작
                timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { _ in
                    withAnimation {
                        currentTip = ZipZipSaTip.getRandomText()
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .onTapGesture {
                // 기존 타이머가 있다면 무효화
                timer?.invalidate()
                // 텍스트 초기화
                withAnimation {
                    currentTip = ZipZipSaTip.getRandomText()
                }
                // 새로운 타이머 시작
                timer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
                    withAnimation {
                        currentTip = ZipZipSaTip.getRandomText()
                    }
                }
            }
    }
    
    var MainButtons: some View {
        HStack(spacing: 11) {
            HomeHuntButton
            ViewedHomeButton
        }
        .padding(.top, 24)
        .padding(.bottom, UIScreen.isSe ? 12 : 64)
        .padding(.horizontal, 16)
    }
    
    var HomeHuntButton: some View {
        Button {
            showHomeHuntSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Button.secondaryYellow)
                .frame(height: ((UIScreen.screenSize.width - 43) / 2) / 166 * 210)
                .overlay(alignment: .bottom) {
                    Image("excitedYongboogiLineHeadCut")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.screenSize.width - 43) / 2, height: (UIScreen.screenSize.width - 43) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .overlay(alignment: .topLeading, content: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ZipLiteral.MainView.homeHuntButtonMain)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .title2)
                        Text(ZipLiteral.MainView.homeHuntButtonSub)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .caption1Regular)
                    }
                    .padding(.top, 12)
                    .padding(.leading, 16)
                })
        }
    }
    
    var ViewedHomeButton: some View {
        NavigationLink(destination: HomeListView()) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Button.primaryBlue)
                .frame(height: ((UIScreen.screenSize.width - 43) / 2) / 166 * 210)
                .overlay(alignment: .bottom) {
                    Image("bowingYongboogiLine")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.screenSize.width - 43) / 2, height: (UIScreen.screenSize.width - 43) / 2)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text(ZipLiteral.MainView.viewedHomeButton)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .title2)
                            .padding(.top, 12)
                            .padding(.leading, 16)
                    }
                }
        }
    }
    
    var RecentlyViewedHomeTitle: some View {
        VStack (alignment: .leading){
            Text(ZipLiteral.MainView.recentlyViewedHomeTitle)
                .foregroundStyle(Color.Text.primary)
                .font(Font.system (size: 24, weight: .bold))
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
    }
    
    var RecentlyViewedHomeList: some View {
        LazyHGrid(rows: [GridItem(.fixed(UIScreen.screenSize.height / 812 * 208))], spacing: 20) {
            ForEach(Array(homes.suffix(3).reversed().enumerated()), id: \.element.id) { index, home in
                Button {
                    if let selectedHomeIndex = homes.firstIndex(where: {$0.id == home.id }) {
                        self.selectedHome = homes[selectedHomeIndex]
                        showHomeResultCardSheet = true
                        print(selectedHomeIndex)
                        print(homes[selectedHomeIndex].homeName)
                    }
                } label: {
                    RecentlyViewedHomeCellView(home: home)
                }
                .contextMenu {
                    DeleteButton(homeData: home)
                }
            }
        }
        .frame(height: UIScreen.screenSize.height / 812 * 208)
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
    }
    
    var EmptyRecentlyViewedHome: some View {
        VStack (alignment: .leading){
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Background.disabled)
                .frame(height: UIScreen.screenSize.height / 812 * 203)
                .overlay(content: {
                    Text(ZipLiteral.MainView.recentlyViewedHomeContent)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                        .foregroundStyle(Color.Text.tertiary)
                        .multilineTextAlignment(.center)
                })
        }
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
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
            deleteTargetHomeData = homeData
            isDeleting = true
        }
    }
}

#Preview {
    MainView()
}
