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
    @Binding var model: UIImage?
    @Binding var homeData: HomeData
    @Binding var showHomeHuntSheet: Bool
    
    var body: some View {
        VStack {
            NavigationTitle
            
            ScrollView {
                ShareCardView(homeData: $homeData)
                    .background(BackgroundForCapture)
                
                ResultDetailViewButton
                ShareButton
            }
        }
        .background(Color.Background.primary)
        .onAppear {
            saveHomeModel()
        }
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
