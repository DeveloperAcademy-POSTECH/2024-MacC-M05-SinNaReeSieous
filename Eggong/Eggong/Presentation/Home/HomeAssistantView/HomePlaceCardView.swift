//
//  HomePlaceCardView.swift
//  Eggong
//
//  Created by YunhakLee on 10/19/24.
//

import SwiftUI

import Kingfisher

struct HomePlaceCardView: View {
    @State var place: Place = Place.dummy1
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
        VStack(spacing: 16) {
            DateAndKeyword
            Thumbnail
            HStack(alignment: .top) {
                NameAndDescription
                Spacer()
                if isFavorite { FavoriteMark.offset(x: 8) }
            }
        }
        .padding(8)
        .background { RoundedRectangle(cornerRadius: 8).fill(Color(.brown50)) }
        .overlay(alignment: .topTrailing) {
            if isBookmarked { Bookmark.offset(x: -18, y: -10) }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 36)
        .task { await fetchData() }
        .onAppear {
            for fontFamily in UIFont.familyNames {
                for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                    print(fontName)
                }
            }
        }
    }
    
    
}

private extension HomePlaceCardView {
    
    // MARK: View-DateAndKeyword
    
    var DateAndKeyword: some View {
        HStack(alignment: .top) {
            DateTextStack
            KeywordTextStack
        }
    }
    
    var DateTextStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(dateTexts, id: \.self) {
                HomePlaceCardTextWithHeight(
                    text: $0,
                    size: 18,
                    font: .pretendard(size: 18, weight: .semiBold),
                    height: 21
                )
                .frame(width: imageWidth/2, alignment: .leading)
            }
        }
    }
    
    var KeywordTextStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(keywordTexts, id: \.self) {
                HomePlaceCardTextWithHeight(
                    text: $0,
                    size: 18,
                    font: .pretendard(size: 18, weight: .semiBold),
                    height: 21
                )
                .frame(width: imageWidth/2, alignment: .leading)
            }
        }
    }
    
    // MARK: View-Thumbnail
    
    var Thumbnail: some View {
        KFImage(URL(string: place.imageURLString))
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    // MARK: View-NameAndDescription
    
    var NameAndDescription: some View {
        VStack(alignment: .leading, spacing: 12) {
            Name
            Description
        }
    }
    
    var Name: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(placeNames, id: \.self) {
                HomePlaceCardTextWithHeight(
                    text: $0,
                    size: 48,
                    font: .appleSDGothicNeo(size: 48, weight: .extraBold),
                    height: 46
                )
            }
        }
    }
    
    var Description: some View {
        HomePlaceCardTextWithHeight(
            text: place.description,
            size: 12,
            font: .appleSDGothicNeo(size: 12, weight: .extraBold),
            height: 12
        )
    }
    
    // MARK: View-Marks
    
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
                .font(.appleSDGothicNeo(size: 10, weight: .extraBold))
                .frame(height: 12)
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
    
    var dateTexts: [String] {
        return dateFormatter.string(from: place.uploadDate)
            .split { $0 == "\n" }
            .map{ String($0) }
    }
    var keywordTexts: [String] {
        return place.keywords.sorted(by: {$0.count < $1.count})
    }
    var placeNames: [String] {
        if place.name.contains(where: {$0 == " "}) {
            return place.name
                .split{ $0 == " " }
                .map{ String($0) }
        } else {
            return ["카페", place.name]
        }
    }
    
    // MARK: Action
    func fetchData() async {
        do {
            self.place = try await placeService.getPlaces().first ?? Place.dummy1
            self.user = try await userService.getUser(id: StringLiterals.Network.dummyUserID)
        } catch {
            print(error)
        }
    }
}

#Preview {
    HomePlaceCardView()
}
