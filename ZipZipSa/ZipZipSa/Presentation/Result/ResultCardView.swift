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
    @State private var firstShow = true
    @Binding var model: UIImage?
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    @State var updateCapture = false
    
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
                if firstShow {
                    saveHomeModel()
                    firstShow = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton
                }
            }
            .task {
                await loadImage()
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
            Text("저장")
                .foregroundStyle(Color.Icon.tertiary)
                .applyZZSFont(zzsFontSet: .bodyBold)
        }
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
                .foregroundStyle(Color.Text.tertiary)
                .applyZZSFont(zzsFontSet: .bodyBold)
        }
        .padding(.bottom, 24)
    }
    
    var ShareButton: some View {
        ShareLink(item: Image(uiImage: card), preview: SharePreview(ZipLiteral.ResultCard.sharePreviewText, icon: ZipLiteral.ResultCard.sharePreviewIcon)) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.Button.primaryBlue)
                .frame(height: 53)
                .overlay(
                    Text(ZipLiteral.ResultCard.shareButtonText)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    func saveHomeModel() {
        if let modelImageData = model?.pngData() {
            homeData.modelImageData = modelImageData
        }
        modelContext.insert(homeData)
        guard let _ = try? modelContext.save() else  {
            return
        }
        print("저장됨!")
    }
    
    private func loadImage() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        updateCapture.toggle()
    }
}
