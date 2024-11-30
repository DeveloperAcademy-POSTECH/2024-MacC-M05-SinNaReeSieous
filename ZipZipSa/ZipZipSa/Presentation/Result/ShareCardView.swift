//
//  ShareCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCardView: View {
    @Binding var homeData: HomeData
    
    let columnLayout = Array(repeating: GridItem(.flexible()), count: 3)
    var criticalTags: [String] {
        return homeData.hazards.map { $0.text }
    }
    
    var availableFacility: [Facility] {
        return homeData.facilities
    }
    
    var resultMaxScores: [String: Float] {
      homeData.loadDictionary(data: homeData.resultMaxScoreData,
                              type: [String: Float].self) ?? [:]
    }
    
    var resultScores: [String: Float] {
        homeData.loadDictionary(data: homeData.resultScoreData,
                              type: [String: Float].self) ?? [:]
    }
    
    let categoryOrders = ["insectproof", "cleanliness", "security", "ventilation", "soundproof", "sunlight"]

    var body: some View {
        VStack {
            ShareCardHeaderView(homeData: $homeData)
            
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
            
            ForEach(categoryOrders.indices, id: \.self) { index in
                let categoryRawValue = categoryOrders[index]
                if let maxScore = resultMaxScores[categoryRawValue],
                   let score = resultScores[categoryRawValue],
                   let category = ChecklistCategory(rawValue: categoryRawValue) {
                    ScoreGraph(category: category.text, maxScore: maxScore, currentScore: score)
                }
            }
//            ScoreGraph(category: "방충", maxScore: 30, currentScore: 5)
//            ScoreGraph(category: "청결", maxScore: 100, currentScore: 80)
//            ScoreGraph(category: "치안", maxScore: 70, currentScore: 70)
//            ScoreGraph(category: "환기", maxScore: 40, currentScore: 30)
//            ScoreGraph(category: "방음", maxScore: 30, currentScore: 16)
//            ScoreGraph(category: "채광", maxScore: 30, currentScore: 25)
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
            
            if !criticalTags.isEmpty {
                LazyVGrid(columns: columnLayout) {
                    ForEach(criticalTags, id: \.self) { tag in
                        ZZSTag(text: tag)
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
            
            if let modelImage = homeData.modelImage {
                Image(uiImage: modelImage)
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
