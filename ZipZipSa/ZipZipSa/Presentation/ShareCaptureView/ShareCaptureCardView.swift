//
//  ShareCaptureCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCaptureCardView: View {

    @Binding var homeData: HomeData
    
    let columnLayout = Array(repeating: GridItem(.flexible()), count: 3)
    var hazardTags: [String] {
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
            ShareCaptureCardHeaderView(homeData: $homeData,
                                       image: homeData.homeImage)
            
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

private extension ShareCaptureCardView {
    // MARK: - View
    
    var ChecklistResult: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.categorySectionTitle)
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
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 4)
    }
    
    var CriticalTags: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.hazardSectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            if !hazardTags.isEmpty {
                LazyVGrid(columns: columnLayout) {
                    ForEach(hazardTags, id: \.self) { tag in
                        ZZSTag(text: tag,
                               textColor: Color.ChecklistTag.colorGray,
                               backgroundColor: Color.ChecklistTag.backgroundGray)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Button.secondaryBlue)
                    .frame(height: 100)
                    .overlay(alignment: .center) {
                        Text(ZipLiteral.ResultCard.hazardSectioinEmptyText)
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
                Text(ZipLiteral.ResultCard.roomModelSectionTitle)
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyBold)
                
                Spacer()
            }
            
            if let modelImage = homeData.modelImage {
                Image(uiImage: modelImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Background.disabled)
                    .frame(height: 140)
                    .overlay(alignment: .center) {
                        Text(ZipLiteral.ResultCard.roomModelSectionEmptyText)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
    
    var NearbyFacilities: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.nearbySectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)
            
            if !availableFacility.isEmpty {
                HStack {
                    ForEach(availableFacility, id: \.self) { facility in
                        Image(facility.icon)
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
                        Text(ZipLiteral.ResultCard.nearbySectionEmptyText)
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }
}
