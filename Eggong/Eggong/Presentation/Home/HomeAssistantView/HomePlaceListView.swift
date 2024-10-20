//
//  HomePlaceListView.swift
//  Eggong
//
//  Created by YunhakLee on 10/20/24.
//

import SwiftUI

struct HomePlaceListView: View {
    @State var places: [Place] = [Place.dummy1, Place.dummy2, Place.dummy3]
    @State var user: User = User.dummy
    
    let placeService: PlaceService = DefaultPlaceService()
    let userService: UserService = DefaultUserService()
    
    let cardHeihgt: CGFloat = (UIScreen.screenSize.width-32)/361*572
    
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
                                    .frame(width: size.width, height: cardHeihgt)
                                    .scaleEffect(min(((1-0.92)/cardHeihgt*minY+1), 1),
                                                 anchor: .center)
                                    .offset(y: minY < 0 ? -minY : 0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(height: cardHeihgt)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .alwaysByOne))
            .scrollIndicators(.hidden)
            .safeAreaPadding(.top, 36)
            .safeAreaPadding(.bottom, UIScreen.screenSize.height-203-cardHeihgt)
        }
        .frame(width: UIScreen.screenSize.width)
        .task {
               await fetchData()
        }
    }
}

extension HomePlaceListView {
    
    // MARK: Action
    
    func fetchData() async {
        do {
            self.places = try await placeService.getPlaces()
            self.user = try await userService.getUser(id: StringLiterals.Network.dummyUserID)
        } catch {
            print(error)
        }
    }
}
#Preview {
    HomePlaceListView()
}
