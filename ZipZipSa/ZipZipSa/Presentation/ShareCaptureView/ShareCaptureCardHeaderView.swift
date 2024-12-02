//
//  ShareCaptureCardHeaderView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ShareCaptureCardHeaderView: View {
    @Binding var homeData: HomeData
    var image: UIImage? 
    var body: some View {
        Image(uiImage: image ?? .basicYongboogiHead)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.screenSize.width-32, height: 340)
            .overlay(Color.black.opacity(0.3))
            .overlay {
                if image == nil {
                    Rectangle()
                        .fill(Color.Button.tertiary)
                        .frame(width: UIScreen.screenSize.width-32, height: 340)
                        .overlay {
                            Image(.charResultCard)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 130)
                        }
                }
            }
            .overlay(contentOverlay)
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16, topTrailing: 16)))
    }
}


private extension ShareCaptureCardHeaderView {
    // MARK: - View
    
    private var contentOverlay: some View {
        VStack(spacing: 0) {
            HomeNicknameAndType
            HomeAddress
            Spacer()
            HomeTags
        }
        .padding(8)
        .frame(height: 340)
    }
    
    var HomeNicknameAndType: some View {
        HStack(alignment: .top) {
            Text(homeData.homeName)
                .foregroundStyle(Color.Tag.colorWhite)
                .applyZZSFont(zzsFontSet: .subheadlineBold)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Tag.backgroundWhite)
                )
            Spacer()
            
            if let type = homeData.homeCategoryType?.text {
                Text(type)
                    .foregroundStyle(Color.Text.onColorSecondary)
                    .applyZZSFont(zzsFontSet: .caption1Bold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                    }
            }
        }
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
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                if homeData.homeAreaPyeong != "" && homeData.homeAreaSquareMeter != "" {
                    ZZSTag(text: "\(homeData.homeAreaPyeong)평/\(homeData.homeAreaSquareMeter)m²")
                    ZZSTag(text: "월세 \(monthlyFee)")
                } else {
                    ZZSTag(text: "월세 \(monthlyFee)")
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 28)
                }
                
            }
            
            HStack(spacing: 6) {
                ZZSTag(text: "보증금 \(deposit)")
                ZZSTag(text: "관리비 \(managementFee)")
            }
        }
    }
    
    var rentalFeeStrings: [String] {
        return homeData.rentalFeeData.map { rentalFee in
            return rentalFee.value
        }
    }

    var monthlyFee: String {
        if homeData.homeRentalType == .fullDeposit {
            return "없음"
        } else {
            return rentalFeeStrings[2].isEmpty ? "없음" : "\(rentalFeeStrings[2])만원"
        }
    }
    
    var managementFee: String {
        return rentalFeeStrings[3].isEmpty ? "없음" : "\(rentalFeeStrings[3])만원"
    }
    
    var deposit: String {
        if rentalFeeStrings[0].isEmpty && rentalFeeStrings[1].isEmpty {
            return "없음"
        } else if rentalFeeStrings[0].isEmpty {
            return "\(rentalFeeStrings[1])억"
        } else if rentalFeeStrings[1].isEmpty {
            return "\(rentalFeeStrings[0])만원"
        } else {
            return "\(rentalFeeStrings[1])억 \(rentalFeeStrings[0])만원"
        }
    }
}
