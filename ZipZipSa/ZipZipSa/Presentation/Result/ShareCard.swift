//
//  ShareCard.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCard: View {
    @Binding var model: UIImage?
    
    var body: some View {
        VStack {
            Header
            
            ChecklistResult
            LineDivider
            
            CriticalTags
            LineDivider
            
            RoomModel
            LineDivider
            
            NearbyFacilities
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 1)
                .background(Color.Layer.first.clipShape(RoundedRectangle(cornerRadius: 16)))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
}

private extension ShareCard {
    // MARK: - View
    
    var Header: some View {
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
    
    var ChecklistResult: some View {
        Group {
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
        }
    }
    
    var LineDivider: some View {
        Line()
            .stroke(style: .init(dash: [2]))
            .foregroundStyle(.gray)
            .frame(height: 1)
            .padding()
    }
    
    var CriticalTags: some View {
        Group {
            Text("TEST TEXT")
            Text("TEST TEXT")
            Text("TEST TEXT")
        }
    }
    
    var RoomModel: some View {
        VStack {
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
            } else {
                Text("모델이 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
    
    var NearbyFacilities: some View {
        HStack {
            ForEach(Facility.allCases, id: \.self) { facility in
                Image(systemName: facility.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
            
        }
        .padding()
    }
}
