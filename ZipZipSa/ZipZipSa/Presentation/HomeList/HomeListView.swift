//
//  HomeListView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/27/24.
//

import SwiftUI

struct HomeListView: View {
    @State private var homeList: [ViewedHome] = [
        ViewedHome(image: "mainPic_sample", title: "첫 번째 집", address: "부산광역시 강서구 녹산산단 382로 10~29번지 (송정동)", rentType: "월세"),
                ViewedHome(image: "mainPic_sample", title: "두 번째 집", address: "서울시 강동구 동남로78길 48 (고덕1동)", rentType: "전세")
    ]  // 데이터 모델을 위한 배열
    
    @State private var showHomeHuntSheet = false
    
    var body: some View {
        ZStack{
            Color.Background.primary
                .ignoresSafeArea()
            
            VStack {
                TopBar
                
                if homeList.isEmpty {
                    NoHome
                } else {
                    ScrollView {
                        ViewedHomeList
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
        .accentColor(Color.Button.tertiary)
        .fullScreenCover(isPresented: $showHomeHuntSheet) {
            EssentialInfoView(showHomeHuntSheet: $showHomeHuntSheet)
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
            Text("내가 본 집")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.leading, 16)
    }
    
    var NoHomeImage: some View {
        Image("cryingYongboogiSquareColor")
            .padding(.top, 60)
    }
    
    var NoHomeText: some View {
        Text("아직 내가 둘러본 집이 없어요.\n집을 보러 가서 집을 추가해 보세요.")
            .foregroundStyle(Color.Text.tertiary)
            .multilineTextAlignment(.center)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.top, 29)
    }
    
    var GoHomeHuntButton: some View {
        Button{
            showHomeHuntSheet = true
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.primaryBlue)
                .frame(width:UIScreen.screenSize.width - 32, height: 44)
                .overlay {
                    Text("용북이와 함께 집 보러 가기")
                        .applyZZSFont(zzsFontSet:.bodyBold)
                        .foregroundStyle(Color.Text.primary)
                }
        }
        .padding(.bottom, 32)
    }
    
    var ViewedHomeList: some View {
           LazyVGrid(columns: [GridItem(.flexible())], spacing: 32) {
               ForEach(homeList.indices, id: \.self) { index in
                   ViewedHomeCellView(home: $homeList[index])
               }
           }
           .padding(.top, 36)
       }
   }

#Preview {
    HomeListView()
}
