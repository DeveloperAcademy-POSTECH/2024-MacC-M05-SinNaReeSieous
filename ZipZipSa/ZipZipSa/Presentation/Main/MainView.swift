//
//  MainView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct MainView: View {
    @State private var currentTip = ZipZipSaTip.getRandomText()
    @State private var timer: Timer?
    var body: some View {
        NavigationStack {
            ZStack{
                Color.Background.primary
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0){
                    topBar
                    ZipZipSaTips
                    mainButtons
                    recentlyViewedHome
                }
                .padding(.horizontal, 16)
                .accentColor(.black)
            }
        }
    }
}

private extension MainView {
    
    var topBar: some View {
        HStack (alignment: .top) {
            navigationTitle
            Spacer()
            settingButton
        }
        .padding(.top, 12)
        .padding(.bottom, 36)
    }
    
    var navigationTitle: some View {
        Text(ZipLiteral.MainView.navigationTitleText)
            .applyZZSFont(zzsFontSet: .largeTitle)
    }
    
    var settingButton: some View {
        NavigationLink(destination: SettingView()) {
            Image(systemName: "gearshape")
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
    
    var mainButtons: some View {
        HStack(spacing: 11) {
            
            homeHuntButton
            viewedHomeButton
        }
        .padding(.top, 20)
        .padding(.bottom, 64)
    }
    
    var homeHuntButton: some View {
        NavigationLink(destination: EssentialInfoView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.secondaryYellow)
                .frame(height: UIScreen.screenSize.height / 812 * 210)
                .overlay(alignment:.leading, content: {
                    VStack (alignment: .leading){
                        Text(ZipLiteral.MainView.homeHuntButtonMain)
                            .applyZZSFont(zzsFontSet: .title2)
                            .padding(.top, 12)
                            .padding(.leading, 16)
                        Text(ZipLiteral.MainView.homeHuntButtonSub)
                            .applyZZSFont(zzsFontSet: .caption2)
                            .padding(.leading, 16)
                        Spacer()
                        
                        Image("excitedYongboogiLineHeadCut")
                            .resizable()
                            .frame(height: UIScreen.screenSize.height / 812 * 147)
                    }
                })
        }
    }
    
    var viewedHomeButton: some View {
        NavigationLink(destination: HomeListView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.primaryBlue)
                .frame(height: UIScreen.screenSize.height / 812 * 210)
                .overlay(alignment:.leading, content: {
                    VStack (alignment: .leading){
                        Text(ZipLiteral.MainView.viewedHomeButton)
                            .applyZZSFont(zzsFontSet: .title2)
                            .padding(.top, 12)
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        Image("bowingYongboogiLine")
                            .resizable()
                            .frame(height: UIScreen.screenSize.height / 812 * 154)
                    }
                })
        }
    }
    
    var recentlyViewedHome: some View {
        VStack (alignment: .leading){
            Text(ZipLiteral.MainView.recentlyViewedHomeTitle)
                .font(Font.system (size: 24, weight: .bold))
                .padding(.bottom, 16)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Background.disabled)
                .frame(height: UIScreen.screenSize.height / 812 * 203)
                .overlay(content: {
                    Text(ZipLiteral.MainView.recentlyViewedHomeContent)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                        .foregroundStyle(Color.Text.tertiary)
                        .multilineTextAlignment(.center)
                })
        }
    }
}

#Preview {
    MainView()
}
