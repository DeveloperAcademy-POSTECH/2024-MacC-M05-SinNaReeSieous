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
    @State var updateCapture = false
    
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
            .task {
                await loadImage()
            }
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
                .onChange(of: updateCapture) { _ , _ in
                    DispatchQueue.main.async {
                        let size = CGSize(width: proxy.size.width, height: proxy.size.height)
                        card = ShareCaptureCardView(homeData: $homeData)
                        .asUIImage(size: size)
                    }
                }
        }
    }
    
    var ResultDetailViewButton: some View {
        NavigationLink {
            DetailEssentialInfoView(homeData: $homeData)
        } label: {
            Text(ZipLiteral.ResultCard.resultDetailButtonText)
                .foregroundStyle(.gray)
                .font(Font.system(size: 16))
        }
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
    
    private func loadImage() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        updateCapture.toggle()
    }
}
