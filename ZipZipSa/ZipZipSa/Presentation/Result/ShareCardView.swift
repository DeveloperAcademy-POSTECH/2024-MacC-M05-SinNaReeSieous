//
//  ShareCardView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCardView: View {
    @Binding var model: UIImage?
    
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
