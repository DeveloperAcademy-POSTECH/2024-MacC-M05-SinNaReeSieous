//
//  Reference.swift
//  Eggong
//
//  Created by YunhakLee on 10/20/24.
//

import SwiftUI

struct Reference: View {
    @State var places: [Place] = [Place.dummy1, Place.dummy2, Place.dummy3]
    let cardHeihgt: CGFloat = UIScreen.screenSize.height-282
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical) {
                VStack(spacing: 200) {
                    ForEach(places) { place in
                        GeometryReader {
                            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
                            HomePlaceCardView()
                                .frame(width: size.width, height: cardHeihgt)
                                .scrollTransition(.interactive, axis: .vertical) { content, phase in
                                    content
                                       //.scaleEffect(phase.value > 0 ? 1 : 0.8, anchor: .center)
                                }
                                .scaleEffect(min(((1-0.92)/cardHeihgt*minY+1), 1), anchor: .center)
                                .offset(y: minY < 0 ? -minY*1.00 : 0)
                        }
                        .frame(height: cardHeihgt)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .alwaysByOne))
            .scrollIndicators(.hidden)
            .safeAreaPadding(.top, 72)
            .safeAreaPadding(.bottom, 156)
        }
        .frame(width: UIScreen.screenSize.width)
    }
}

#Preview {
    Reference()
}
