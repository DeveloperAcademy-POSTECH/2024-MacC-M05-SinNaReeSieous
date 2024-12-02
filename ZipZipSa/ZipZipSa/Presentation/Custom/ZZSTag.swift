//
//  ZZSTag.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ZZSTag: View {
    let text: String
    let textColor: Color
    let backgroundColor: Color
    
    init(text: String, textColor: Color = Color.Tag.colorWhite, backgroundColor: Color = Color.Tag.backgroundWhite) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(backgroundColor)
            .frame(height: 28)
            .overlay {
                Text(text)
                    .foregroundStyle(textColor)
                    .applyZZSFont(zzsFontSet: .footnote)
            }
    }
}

#Preview {
    ZZSTag(text: "보증금 0000만원")
}
