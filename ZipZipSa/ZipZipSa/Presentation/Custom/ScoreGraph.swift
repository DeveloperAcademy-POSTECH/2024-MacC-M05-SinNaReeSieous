//
//  ScoreGraph.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ScoreGraph: View {
    let category: String
    let maxScore: Float
    let currentScore: Float
    let horizontalPadding: Float = 64
    let componentPadding: Float = 8
    let chipWidth: Float = 45
    let viewWidth: Float = Float(UIScreen.screenSize.width)
    
    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ChecklistTag.backgroundYellow)
                .frame(width: 45, height: 24)
                .overlay() {
                    Text(category)
                        .foregroundStyle(Color.ChecklistTag.colorYellow)
                        .applyZZSFont(zzsFontSet: .footnote)
                }
                .padding(.trailing, 8)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Background.secondary)
                .frame(width: CGFloat(backgroundWidth), height: 24)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.zzsBlue20)
                        .frame(width: CGFloat(foregroundWidth), height: 24)
                }
        }
        .padding(.bottom, 12)
    }
}

private extension ScoreGraph {
    // MARK: - ComputedValue
    
    var backgroundWidth: Float {
        viewWidth - (chipWidth + horizontalPadding + componentPadding)
    }
    
    var foregroundWidth: Float {
        backgroundWidth / maxScore * currentScore
    }
}
