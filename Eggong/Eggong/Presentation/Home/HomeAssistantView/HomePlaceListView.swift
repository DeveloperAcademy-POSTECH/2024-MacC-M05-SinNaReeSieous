//
//  HomePlaceListView.swift
//  Eggong
//
//  Created by YunhakLee on 10/20/24.
//

import SwiftUI

struct HomePlaceListView: View {
    @Binding var places: [Place]
    @Binding var user: User

    let cardHeight: CGFloat = (UIScreen.screenSize.width-32)/361*572
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical) {
                VStack(spacing: 48) {
                    ForEach($places) { place in
                        GeometryReader {
                            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
                            NavigationLink(destination: PlaceDetailView(placeID: place.id)) {
                                HomePlaceCardView(place: place, user: $user)
                                    .frame(width: size.width, height: cardHeight)
                                    .scaleEffect(min(((1-0.92)/cardHeight*minY+1), 1),
                                                 anchor: .center)
                                    .offset(y: minY < 0 ? -minY : 0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(height: cardHeight)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            .safeAreaPadding(.top, 36)
            .safeAreaPadding(.bottom, UIScreen.screenSize.height-203-cardHeight)
        }
        .frame(width: UIScreen.screenSize.width)
    }
}

#Preview {
    HomePlaceListView(places: .constant([.dummy1, .dummy2, .dummy3]), user: .constant(.dummy))
}
