//
//  PlaceDetailHeaderView.swift
//  Eggong
//
//  Created by 조우현 on 10/19/24.
//

import SwiftUI

struct PlaceDetailHeaderView: View {
    var scrollOffset: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(.sampleThumbnail)
                .resizable()
                .scaledToFill()
                .frame(height: max(340 + scrollOffset, 340))
                .clipped()
                .overlay {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                }
            
            VStack(alignment: .leading) {
                Text("카페 휙")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                HStack(spacing: 20) {
                    Text("따뜻한")
                    Text("자유로운")
                    Text("풋풋한")
                }
                .foregroundStyle(.white)
                .font(.caption)
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PlaceDetailHeaderView(scrollOffset: 0)
}
