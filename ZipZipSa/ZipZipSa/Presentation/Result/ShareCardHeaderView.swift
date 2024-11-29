//
//  ShareCardHeaderView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ShareCardHeaderView: View {
    var body: some View {
        let image = Image(uiImage: UIImage(resource: .mainPicSample))
            .resizable()
            .scaledToFill()
        
        return image
            .frame(height: 340)
            .overlay(Color.black.opacity(0.3))
            .overlay {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        RoomNickname
                        Spacer()
                        RoomType
                    }
                    .padding(.top, 8)
                    
                    RoomAddress
                    
                    Spacer()
                    
                    RoomTags
                }
                .padding(8)
            }
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16, topTrailing: 16)))
    }
}

private extension ShareCardHeaderView {
    // MARK: - View
    
    var RoomNickname: some View {
        Text("세 번째 집")
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
        Text("부산광역시 강서구 녹산산단 382로 14번가길 10~29번지 (송정동)")
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
