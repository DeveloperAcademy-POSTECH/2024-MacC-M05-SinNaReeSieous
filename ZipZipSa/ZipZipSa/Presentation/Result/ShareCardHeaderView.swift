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
        VStack() {
            HStack(alignment: .top) {
                RoomNickname
                Spacer()
                RoomType
            }
            .padding(.top, 8)
            
            HStack {
                RoomAddress
                Spacer()
            }
            
            Spacer()
            
            if mainPicture == nil {
                Image(.charResultCard)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
                    .padding(.top, 14)
                    .padding(.bottom, 54)
            }
            
            RoomTags
        }
        .padding(8)
    }
    
    var RoomNickname: some View {
        Text(homeData.homeName)
            .foregroundStyle(Color.Tag.colorGray)
            .applyZZSFont(zzsFontSet: .subheadlineBold)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.Tag.backgroundGray)
                    .frame(height: 32)
            )
    }
    
    var RoomType: some View {
        Text("빌라")
            .foregroundStyle(Color.Text.onColorSecondary)
            .applyZZSFont(zzsFontSet: .caption1Bold)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                    .frame(height: 22)
            )
    }
    
    var RoomAddress: some View {
        Text(homeData.locationText ?? "")
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .caption1Bold)
    }
    
    var RoomTags: some View {
        HStack(spacing: 6) {
            ZZSTag(text: "보증금 0000만원")
            ZZSTag(text: "보증금 0000만원")
            ZZSTag(text: "보증금 0000만원")
        }
    }
}
