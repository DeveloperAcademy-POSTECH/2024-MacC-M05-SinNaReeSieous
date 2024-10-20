//
//  HomePlaceCardView.swift
//  Eggong
//
//  Created by YunhakLee on 10/19/24.
//

import SwiftUI

import Kingfisher

struct HomePlaceCardView: View {
    @State var place: Place = Place.dummy
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
            DateAndKeyword
                .padding(.bottom, 16)
            Thumbnail
            HStack(alignment: .top) {
                NameAndDescription
                Spacer()
                if isFavorite {
                    FavoriteMark
                        .offset(x: 12, y: 16)
                }
            }
        }
        .padding(8)
        .background { RoundedRectangle(cornerRadius: 8).fill(Color(.brown50))}
        .overlay(alignment: .topTrailing) {
            if isBookmarked {
                Bookmark
                    .offset(x: -18, y: -10)
            }
        }
        .padding(.horizontal, 16)
        .task {
            do {
                self.place = try await placeService.getPlaces().first ?? Place.dummy
                self.user = try await userService.getUser(id: StringLiterals.Network.dummyUserID)
            } catch {
                print(error)
            }
        }
    }
    
    
}

private extension HomePlaceCardView {
    
    // MARK: View
    
    var DateAndKeyword: some View {
        HStack(alignment: .top) {
            Text(dateFormatter.string(from: place.uploadDate))
                .foregroundStyle(.black)
                .font(.SDGothicNeo(size: 18, weight: .semibold))
                .kerning(-18*0.02)
                .frame(width: imageWidth/2, alignment: .leading)
            Text(keywordText)
                .foregroundStyle(.black)
                .font(.SDGothicNeo(size: 18, weight: .semibold))
                .kerning(-18*0.02)
                .frame(width: imageWidth/2, alignment: .leading)
        }
    }
    
    var Thumbnail: some View {
        KFImage(URL(string: place.imageURLString))
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    var Name: some View {
        VStack(alignment: .leading, spacing: -18) {
            Text(placeName[0])
                .foregroundStyle(.black)
                .font(.SDGothicNeo(size: 48, weight: .extraBold))
                .kerning(-48*0.02)
            Text(placeName[1])
                .foregroundStyle(.black)
                .font(.SDGothicNeo(size: 48, weight: .extraBold))
                .kerning(-48*0.02)
        }
    }
    
    var NameAndDescription: some View {
        VStack(alignment: .leading, spacing: 0) {
            Name
            Text(place.description)
                .foregroundStyle(.black)
                .font(.SDGothicNeo(size: 12, weight: .extraBold))
                .kerning(-12*0.02)
        }
    }
    
    var Bookmark: some View {
        Image(systemName: "bookmark.fill")
            .foregroundStyle(.accent)
            .font(.system(size: 36, weight: .regular))
    }
    
    var FavoriteMark: some View {
        HStack(spacing: 4) {
            Image(systemName: "heart.fill")
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .regular))
            Text("아끼는 공간")
                .foregroundStyle(.white)
                .font(.SDGothicNeo(size: 10, weight: .extraBold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background { Color.black }
    }
    
    // MARK: Computed Values
    
    var isBookmarked: Bool {
        user.bookmarkPlaces.contains(place.id ?? "")
    }
    var isFavorite: Bool {
        user.favoritePlaces.contains(place.id ?? "")
    }
    
    var imageWidth: CGFloat {
        UIScreen.screenSize.width-imageHorizontalPadding*2
    }
    var imageHeight: CGFloat {
        imageWidth/345*349
    }
    
    var keywordText: String {
        let sortedKeywords = place.keywords.sorted(by: {$0.count < $1.count})
        return sortedKeywords.joined(separator: "\n")
    }
    var placeName: [String] {
        if place.name.contains(where: {$0 == " "}) {
            return place.name
                .split{ $0 == " " }
                .map{ String($0) }
        } else {
            return ["카페", place.name]
        }
    }
}

#Preview {
    HomePlaceCardView()
}
