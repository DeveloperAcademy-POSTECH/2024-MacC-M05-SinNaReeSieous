//
//  ResultCardView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

struct ResultCardView: View {

    @Environment(\.modelContext) private var modelContext
    
    @State private var card: UIImage = UIImage()
    @State private var mainPicture: UIImage? = UIImage(resource: .mainPicSample)
    @State private var hazardTags: [Hazard] = [.cigaretteSmell, .cockroach, .mold]
    @Binding var model: UIImage?
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationTitle
                
                ScrollView {
                    ShareCardView(homeData: $homeData)
                        .background(BackgroundForCapture)
                    
                    ResultDetailViewButton
                    ShareButton
                }
                .scrollIndicators(.never)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.Background.primary)
            .onAppear {
                saveHomeModel()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton
                }
            }
        }
    }
}

private extension ResultCardView {
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
    }
    
    var CloseButton: some View {
        Button {
            showHomeHuntSheet = false
        } label: {
            Text("완료")
                .foregroundStyle(Color.Icon.tertiary)
                .applyZZSFont(zzsFontSet: .bodyBold)
        }
    }
    
    var BackgroundForCapture: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        let size = CGSize(width: proxy.size.width, height: proxy.size.height)
                        card = ShareCardView(homeData: $homeData)
                            .asUIImage(size: size)
                    }
                }
        }
    }
    
    var ResultDetailViewButton: some View {
        Button {
            // TODO: 상세보기뷰로 이동
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
    
    func saveHomeModel() {
        print(homeData.homeName)
        if let modelImageData = model?.pngData() {
            homeData.modelImageData = modelImageData
        }
        modelContext.insert(homeData)
        guard let _ = try? modelContext.save() else  {
            return
        }
        print("저장됨!")
    }
}
