//
//  ShareCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCardView: View {
    @Binding var homeCategory: HomeCategory?
    @Binding var homeDirection: HomeDirection?
    @Binding var hazaedTags: [Hazard]
    @Binding var model: UIImage?
    @Binding var mainPicture: UIImage?
    
    let columnLayout = Array(repeating: GridItem(), count: 3)
    let availableFacility: [Facility] = []
    
    var body: some View {
        VStack {
            ShareCardHeaderView(mainPicture: $mainPicture, homeCategory: $homeCategory, homeDirection: $homeDirection)
            
            ChecklistResult
            ZZSSperator()
            
            CriticalTags
            ZZSSperator()
            
            RoomModel
            ZZSSperator()
            
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

private extension ShareCardView {
    // MARK: - View
    
    var ChecklistResult: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("카테고리")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            ScoreGraph(category: ChecklistCategory.insectproof.text, maxScore: 30, currentScore: 5)
            ScoreGraph(category: ChecklistCategory.cleanliness.text, maxScore: 100, currentScore: 80)
            ScoreGraph(category: ChecklistCategory.security.text, maxScore: 70, currentScore: 70)
            ScoreGraph(category: ChecklistCategory.ventilation.text, maxScore: 40, currentScore: 30)
            ScoreGraph(category: ChecklistCategory.soundproof.text, maxScore: 30, currentScore: 16)
            ScoreGraph(category: ChecklistCategory.sunlight.text, maxScore: 30, currentScore: 25)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 4)
    }
    
    var CriticalTags: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("필수체크")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            if !hazaedTags.isEmpty {
                LazyVGrid(columns: columnLayout) {
                    ForEach(hazaedTags, id: \.self) { tag in
                        ZZSTag(text: tag.text)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Button.secondaryBlue)
                    .frame(height: 100)
                    .overlay(alignment: .center) {
                        Text("우와, 여기는 안전한 곳이에요!")
                            .foregroundStyle(Color.Text.secondary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }
    
    var RoomModel: some View {
        VStack(spacing: 0) {
            HStack {
                Text("집 구조")
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyBold)
                
                Spacer()
            }
            .padding(.bottom, 12)
            
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Background.disabled)
                    .frame(height: 140)
                    .overlay(alignment: .center) {
                        Text("집 구조 등록으로 내게 꼭 맞는 집을\n더 쉽게 찾아보세요")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }
    
    var NearbyFacilities: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("주변 시설")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            if !availableFacility.isEmpty {
                HStack {
                    ForEach(availableFacility, id: \.self) { facility in
                        Image(systemName: facility.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 29, height: 29)
                    }
                    Spacer()
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Background.disabled)
                    .frame(height: 29)
                    .overlay(alignment: .center) {
                        Text("이 집 주변에는 시설이 없어요")
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }
}
