//
//  ShareCardHeaderView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ShareCardHeaderView: View {
    @Binding var homeData: HomeData
    
    var mainPicture: UIImage? {
        homeData.homeImage
    }
    
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
            Text(homeData.homeName)
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
            Text(homeData.locationText ?? "")
                .foregroundStyle(Color.Text.onColorPrimary)
                .applyZZSFont(zzsFontSet: .caption1Bold)
            Spacer()
        }
    }
    
    var HomeTags: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                if let category = homeData.homeCategoryType?.text{
                    ZZSTag(text: category)
                }
                if let direction = homeData.homeDirectionType?.text  {
                    ZZSTag(text: direction)
                }
                if homeData.homeAreaPyeong != "" && homeData.homeAreaSquareMeter != "" {
                    ZZSTag(text: "\(homeData.homeAreaPyeong)평/\(homeData.homeAreaSquareMeter)m²")
                }
            }
            
            HStack(spacing: 6) {
                ZZSTag(text: "보증금 \(rentalFeeStrings[0])")
                ZZSTag(text: "월세 \(rentalFeeStrings[2])")
                ZZSTag(text: "관리비 \(rentalFeeStrings[3])")
            }
        }
    }
    
    var rentalFeeStrings: [String] {
        return homeData.rentalFeeData.map { rentalFee in
            return rentalFee.value.isEmpty ? "없음" : "\(rentalFee.value)만원"
        }
    }
}
