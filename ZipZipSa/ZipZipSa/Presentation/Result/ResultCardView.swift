//
//  ResultCardView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ResultCardView: View {
    @State var homeCategory: HomeCategory? = .villa
    @State var homeDirection: HomeDirection? = .south
    @State private var card: UIImage = UIImage()
    @State private var mainPicture: UIImage? = UIImage(resource: .mainPicSample)
    @State private var hazaedTags: [Hazard] = [.cigaretteSmell, .cockroach, .mold]
    @Binding var model: UIImage?
    
    var body: some View {
        VStack {
            NavigationTitle
            
            ScrollView {
                ShareCardView(homeCategory: $homeCategory, homeDirection: $homeDirection, hazaedTags: $hazaedTags, model: $model, mainPicture: $mainPicture)
                    .background(BackgroundForCapture)
                
                ResultDetailViewButton
                ShareButton
            }
        }
        .background(Color.Background.primary)
    }
}

private extension ResultCardView {
    // MARK: - View
    
    var NavigationTitle: some View {
        HStack {
            Text("집 요약 카드예요")
                .applyZZSFont(zzsFontSet: .title2)
                .foregroundStyle(Color.Text.primary)
            
            Spacer()
        }
        .padding(.top, 14)
        .padding(.horizontal, 16)
        .padding(.bottom, 34)
    }
    
    var BackgroundForCapture: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        let size = CGSize(width: proxy.size.width, height: proxy.size.height)
                        card = ShareCardView(homeCategory: $homeCategory, homeDirection: $homeDirection, hazaedTags: $hazaedTags, model: $model, mainPicture: $mainPicture)
                            .asUIImage(size: size)
                    }
                }
        }
    }
    
    var ResultDetailViewButton: some View {
        Button {
            // TODO: 상세보기뷰로 이동
        } label: {
            Text("상세보기")
                .foregroundStyle(.gray)
                .font(Font.system(size: 16))
        }
        .padding(.bottom, 24)
    }
    
    var ShareButton: some View {
        ShareLink(item: Image(uiImage: card), preview: SharePreview("집 요약 카드 공유", icon: "AppIcon")) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.primary)
                .frame(height: 53)
                .overlay(
                    Text("공유하기")
                        .foregroundStyle(Color.white)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}
