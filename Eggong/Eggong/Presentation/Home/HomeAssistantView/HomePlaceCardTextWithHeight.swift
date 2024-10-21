//
//  HomePlaceCardTextWithHeight.swift
//  Eggong
//
//  Created by YunhakLee on 10/20/24.
//

import SwiftUI

struct HomePlaceCardTextWithHeight: View {
    let text: String
    let size: CGFloat
    let font: Font
    let height: CGFloat
    
    var body: some View {
        Text(text)
            .foregroundStyle(.black)
            .font(font)
            .kerning(-size*0.02)
            .frame(height: height)
    }
}

#Preview {
    PlaceDetailView()
}
