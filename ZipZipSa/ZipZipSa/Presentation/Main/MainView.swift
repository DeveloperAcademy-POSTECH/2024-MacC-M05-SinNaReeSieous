//
//  MainView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct MainView: View {
    @State private var currentTip = ZipZipSaTip.getRandomText()
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0){
                TopBar
                ZipZipSaTips
                MainButtons
                
                Spacer()
                
                RecentlyViewedHome
            }
            .padding(.horizontal, 16)
            .accentColor(.black)
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
        .padding(.bottom, 36)
    }
    
    var NavigationTitle: some View {
        Text("어떤 집을 \n보러 갈까요?")
            .font(Font.system (size: 28, weight: .bold))
    }
    
    var SettingButton: some View {
        NavigationLink(destination: SettingView()) {
            Image(systemName: "gearshape")
                .font(Font.system (size: 24))
        }
    }
    
    var ZipZipSaTips : some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(.black, lineWidth:1)
            .frame(height: 61)
            .overlay(alignment: .leading, content: {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 34)
                        .foregroundColor(.green)
                    Text(currentTip)
                        .font(Font.system (size: 12, weight: .medium))
                        .lineLimit(3)
                        .transition(.slide)
                        .animation(.easeInOut, value: currentTip)
                }
                .padding(.leading, 12)
                .padding(.trailing, 8)
            })
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
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
        .padding(.top, 20)
    }
    
    var HomeHuntButton: some View {
        NavigationLink(destination: SettingView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow)
                .frame(height: UIScreen.screenSize.height / 812 * 210)
                .overlay(alignment:.leading, content: {
                    VStack (alignment: .leading){
                        Text("집 보러가기")
                            .font(Font.system (size: 21, weight: .bold))
                            .padding(.top, 12)
                            .padding(.leading, 16)
                        Text("용북이와 함께 집을 둘러보아요")
                            .font(Font.system (size: 10, weight: .medium))
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        Image("excitedYongboogiLineHeadCut")
                            .resizable()
                            .frame(height: UIScreen.screenSize.height / 812 * 147)
                    }
                })
        }
    }
    
    var ViewedHomeButton: some View {
        NavigationLink(destination: HomeListView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cyan)
                .frame(height: UIScreen.screenSize.height / 812 * 210)
                .overlay(alignment:.leading, content: {
                    VStack (alignment: .leading){
                        Text("내가 본 집")
                            .font(Font.system (size: 21, weight: .bold))
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
    
    var RecentlyViewedHome: some View {
        VStack (alignment: .leading){
            Text("최근 본 집")
                .font(Font.system (size: 24, weight: .bold))
                .padding(.bottom, 16)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(height: UIScreen.screenSize.height / 812 * 203)
                .overlay(content: {
                    Text("아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요.")
                        .font(Font.system (size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                })
        }
    }
}

#Preview {
    MainView()
}
