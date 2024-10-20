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

extension User {
    static let dummy = User(
        id: "J4TRZmkvNbUqPM9xT2NVOa6DZrw2",
        bookmarkPlaces: ["LQXiQ1h77EJsmX7daDpG"],
        favoritePlaces: ["LQXiQ1h77EJsmX7daDpG"],
        profileImageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Users%2FJ4TRZmkvNbUqPM9xT2NVOa6DZrw2%2FE019562A-6CEF-49D5-9A94-AF161E57EB35.jpg?alt=media&token=6b443e7e-b3df-4d28-8270-51645d9d5254"

    )
}
