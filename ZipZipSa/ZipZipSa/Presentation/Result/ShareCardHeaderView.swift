//
//  ShareCardHeaderView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ShareCardHeaderView: View {
    @Binding var mainPicture: UIImage?
    @Binding var homeCategory: HomeCategory
    @Binding var homeDirection: HomeDirection
    @State var homeAreaPyeong: String = "16"
    @State var homeAreaSquareMeter: String = "52.89"
    @State var diposit: String = "5000"
    @State var rentalFee: String = "30"
    @State var maintenceFee: String = "10"
    @State var homeNikcname: String = "세 번째 집"
    @State var homeAddress: String = "부산광역시 강서구 녹산산단 382로 14번가길 10~29번지 (송정동)"
    
    let columnLayout = Array(repeating: GridItem(), count: 3)
    
    var body: some View {
        content
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16, topTrailing: 16)))
    }
    
    @ViewBuilder
    private var content: some View {
        if let image = mainPicture {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 340)
                .overlay(Color.black.opacity(0.3))
                .overlay(contentOverlay)
        } else {
            Rectangle()
                .fill(Color.Button.tertiary)
                .frame(height: 340)
                .overlay(contentOverlay)
        }
    }
}

private extension ShareCardHeaderView {
    // MARK: - View
    
    private var contentOverlay: some View {
        VStack {
            HomeNickname
            HomeAddress
            
            Spacer()
            
            if mainPicture == nil {
                Image(.charResultCard)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
                    .padding(.top, 14)
                    .padding(.bottom, 54)
            }
            
            HomeTags
        }
        .padding(8)
    }
    
    var HomeNickname: some View {
        HStack {
            Text(homeNikcname)
                .foregroundStyle(Color.Tag.colorWhite)
                .applyZZSFont(zzsFontSet: .subheadlineBold)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Tag.backgroundWhite)
                        .frame(height: 32)
                )
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 6)
    }
    
    var HomeAddress: some View {
        HStack {
            Text(homeAddress)
                .foregroundStyle(Color.Text.onColorPrimary)
                .applyZZSFont(zzsFontSet: .caption1Bold)
            Spacer()
        }
    }
    
    var HomeTags: some View {
        LazyVGrid(columns: columnLayout) {
            ZZSTag(text: homeCategory.text)
            ZZSTag(text: homeDirection.text)
            ZZSTag(text: "\(homeAreaPyeong)평/\(homeAreaSquareMeter)m²")
            ZZSTag(text: "보증금 \(diposit)만원")
            ZZSTag(text: "월세 \(rentalFee)만원")
            ZZSTag(text: "관리비 \(maintenceFee)만원")
        }
    }
}
