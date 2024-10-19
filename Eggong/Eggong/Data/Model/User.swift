//
//  User.swift
//  Eggong
//
//  Created by YunhakLee on 10/19/24.
//

import Foundation

struct User: FirebaseCodable, Identifiable {
    var id: String?
    var bookmarkPlaces: [String]
    var favoritePlaces: [String]
    var profileImageURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookmarkPlaces
        case favoritePlaces
        case profileImageURLString
    }
}
