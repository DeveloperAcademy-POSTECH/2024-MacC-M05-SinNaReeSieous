//
//  MainView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct MainView: View {
    @State private var homeList: [ViewedHome] = [
        ViewedHome(image: "mainPic_sample", title: "첫 번째 집", address: "부산광역시 강서구 녹산산단 382로 10~29번지 (송정동)", rentType: "월세"),
        ViewedHome(image: "mainPic_sample", title: "두 번째 집", address: "서울시 강동구 동남로78길 48 (고덕1동)", rentType: "전세")
    ]  // 데이터 모델을 위한 배열
    @State private var currentTip = ZipZipSaTip.getRandomText()
    @State private var timer: Timer?
    @State private var showHomeHuntSheet: Bool = false
    
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
                    
                    if homeList.isEmpty {
                        EmptyRecentlyViewedHome
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            RecentlyViewedHomeList
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .accentColor(Color.Button.tertiary)
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $showHomeHuntSheet) {
            EssentialInfoView(showHomeHuntSheet: $showHomeHuntSheet)
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
            .frame(height: 61)
            .overlay(alignment: .leading, content: {
                HStack(spacing: 12) {
                    Image("basicYongboogiHeadColor")
                        .resizable()
                        .frame(width: 36, height: 34)
                        .foregroundColor(.green)
                    Text(currentTip)
                        .applyZZSFont(zzsFontSet: .footnote)
                        .lineLimit(3)
                        .transition(.slide)
                        .animation(.easeInOut, value: currentTip)
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
            })
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
        .padding(.bottom, 64)
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
                            .applyZZSFont(zzsFontSet: .caption2)
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
    }
    
    var RecentlyViewedHomeList: some View {
        LazyHGrid(rows: [GridItem(.fixed(UIScreen.screenSize.height / 812 * 208))], spacing: 20) {
            ForEach(Array(homeList.suffix(3).reversed().enumerated()), id: \.element.id) { index, home in
                RecentlyViewedHomeCellView(home: $homeList[homeList.count - 1 - index])
            }
        }
        .frame(height: UIScreen.screenSize.height / 812 * 208)
        .padding(.bottom, 8)
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
    }
}

#Preview {
    MainView()
}
