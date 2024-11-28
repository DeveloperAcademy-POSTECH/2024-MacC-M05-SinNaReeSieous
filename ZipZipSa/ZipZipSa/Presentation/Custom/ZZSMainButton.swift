//
//  ZZSMainButton.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/23/24.
//

import SwiftUI

struct ZZSMainButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Button.primaryBlue)
                .frame(height: 53)
                .overlay {
                    Text(text)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                }
        }
    }
}

#Preview {
    ZZSMainButton(action: {}, text: "완료")
}
