//
//  ResultCardSheet.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/30/24.
//

import SwiftUI
import SwiftData

struct ResultCardSheetView: View {
    @Query var homes: [HomeData]
    @State private var card: UIImage = UIImage()
    @Binding var homeData: HomeData
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationTitle
                
                ScrollView {
                    ShareCardSheet(homeData: $homeData)
                        .background(BackgroundForCapture)
                    
                    ResultDetailViewButton
                    ShareButton
                }
                .scrollIndicators(.never)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.Background.primary)
        }
    }
}

private extension ResultCardSheetView {
    // MARK: - View
    
    var NavigationTitle: some View {
        HStack {
            Text(ZipLiteral.ResultCard.navigationTitleText)
                .applyZZSFont(zzsFontSet: .title2)
                .foregroundStyle(Color.Text.primary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .padding(.top, 24)
    }
    
    var BackgroundForCapture: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        let size = CGSize(width: proxy.size.width, height: proxy.size.height)
                        card = ShareCardSheet(homeData: $homeData)
                            .asUIImage(size: size)
                    }
                }
        }
    }
    
    var ResultDetailViewButton: some View {
        NavigationLink(destination: {
            DetailEssentialInfoView(homeData: $homeData)
        }, label: {
            Text(ZipLiteral.ResultCard.resultDetailButtonText)
                .foregroundStyle(.gray)
                .font(Font.system(size: 16))
        })
        .padding(.bottom, 24)
    }
    
    var ShareButton: some View {
        ShareLink(item: Image(uiImage: card), preview: SharePreview(ZipLiteral.ResultCard.sharePreviewText, icon: ZipLiteral.ResultCard.sharePreviewIcon)) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.primary)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.ResultCard.shareButtonText)
                        .foregroundStyle(Color.white)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}
