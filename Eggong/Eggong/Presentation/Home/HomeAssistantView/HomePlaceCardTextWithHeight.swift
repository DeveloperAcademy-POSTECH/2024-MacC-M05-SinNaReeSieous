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
    let weight: SDGothicNeoFontWeight
    let height: CGFloat
    
    var body: some View {
        Text(text)
            .foregroundStyle(.black)
            .font(.SDGothicNeo(size: size, weight: .bold))
            .kerning(-size*0.02)
            .frame(height: height)
    }
}

#Preview {
    PlaceDetailView()
}
