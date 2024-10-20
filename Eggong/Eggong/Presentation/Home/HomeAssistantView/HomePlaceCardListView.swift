//
//  HomePlaceCardListView.swift
//  Eggong
//
//  Created by YunhakLee on 10/20/24.
//

import SwiftUI

struct HomePlaceCardListView: View {
    @State var places: [Place] = [Place.dummy1, Place.dummy1, Place.dummy1]
    @State var user: User = User.dummy
    
    let placeService: PlaceService = DefaultPlaceService()
    let userService: UserService = DefaultUserService()
    let imageHorizontalPadding: CGFloat = 24
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년\nM월d일"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 167)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(places.indices, id: \.self) { index in
                        HomePlaceCardView()
                            .frame(height: UIScreen.screenSize.height-167, alignment: .top)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect( phase.value < 0 ? 0.8 : 1)
                                    //.opacity(phase.isIdentity ? 1 : 0)
                                   //.offset(y: CGFloat(phase.isIdentity ? 700*(index) : 0))
                            }
                            
                    }
                }
                .scrollTargetLayout()
            }
            .ignoresSafeArea()
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.hidden)
            .task {
                //   await fetchData()
            }
        }
        .ignoresSafeArea()
    }
}

extension HomePlaceCardListView {
    
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
    HomePlaceCardListView()
}
