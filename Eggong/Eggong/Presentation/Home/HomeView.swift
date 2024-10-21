//
//  HomeView.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

import Kingfisher

struct HomeView: View {
    @State private var showSheet: SheetType?
    @State var selectedTab: Tab = .random
    @State var places: [Place] = []
    @State var user: User = User.dummy
    
    let placeService: PlaceService = DefaultPlaceService()
    let userService: UserService = DefaultUserService()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomePlaceOrderTabView(selectedTab: $selectedTab)
                HomePlaceListView(places: $places, user: $user)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CurrentLocationView
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ToolbarButtonView
                }
            }
            .animation(.easeInOut, value: selectedTab)
            .sheet(item: $showSheet) { sheetType in
                SheetView(type: sheetType, showSheet: $showSheet)
            }
            .task {
                await fetchData()
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                switch newValue {
                case .random:
                    places.shuffle()
                case .distance:
                    places.sort(by: { $0.distance < $1.distance })
                case .latest:
                    places.sort(by: { $0.uploadDate > $1.uploadDate })
                }
            }
        }
    }
}

private extension HomeView {
    
    var CurrentLocationView: some View {
        Text("효곡동")
            .foregroundStyle(.black)
            .font(.pretendard(size: 22, weight: .extraBold))
    }
    
    var ToolbarButtonView: some View {
        HStack(spacing: 8) {
            Button {
                showSheet = .bookmark
            } label: {
                Image(systemName: "bookmark.circle.fill")
                    .tint(.brown200)
                    .font(.system(size: 21.8))
                    .frame(width: 28, height: 28)
            }
            Button {
                showSheet = .myPage
            } label: {
                KFImage(URL(string: user.profileImageURLString))
                    .placeholder {
                        Image(.placeHolder)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
            }
        }
    }
    
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
    HomeView()
}
