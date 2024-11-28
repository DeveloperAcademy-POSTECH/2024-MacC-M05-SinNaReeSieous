//
//  ZZSTag.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ZZSTag: View {
    let text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.Tag.backgroundWhite)
            .frame(height: 28)
            .overlay {
                Text(text)
                    .foregroundStyle(Color.Tag.colorWhite)
                    .applyZZSFont(zzsFontSet: .footnote)
            }
    }
}

#Preview {
    ZZSTag(text: "보증금 0000만원")
}
