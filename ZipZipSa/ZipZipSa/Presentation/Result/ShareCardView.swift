//
//  ShareCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCardView: View {
    @Binding var model: UIImage?
    
    let columnLayout = Array(repeating: GridItem(), count: 3)
    let criticalTags: [String] = ["바퀴위험", "곰팡이 위험", "담배 위험", "사생활 위험", "소음 위험", "누수 위험", "수압 안좋음", "배수 안좋음", "온수 잘 안 나옴"]
    
    var body: some View {
        VStack {
            ShareCardHeaderView()
            
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
            
            ScoreGraph(category: "방충", maxScore: 30, currentScore: 5)
            ScoreGraph(category: "청결", maxScore: 100, currentScore: 80)
            ScoreGraph(category: "치안", maxScore: 70, currentScore: 70)
            ScoreGraph(category: "환기", maxScore: 40, currentScore: 30)
            ScoreGraph(category: "방음", maxScore: 30, currentScore: 16)
            ScoreGraph(category: "채광", maxScore: 30, currentScore: 25)
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
            
            LazyVGrid(columns: columnLayout) {
                ForEach(criticalTags, id: \.self) { tag in
                    ZZSTag(text: tag)
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
                Text("모델이 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
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
            
            HStack {
                ForEach(Facility.allCases, id: \.self) { facility in
                    Image(systemName: facility.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 29, height: 29)
                }
                Spacer()
            }
        }
        .padding(16)
    }
}