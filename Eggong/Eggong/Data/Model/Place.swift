//
//  Place.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

struct Place: FirebaseCodable, Identifiable {
    var id: String?
    var name: String
    var keywords: [String]
    var description: String
    var imageURLString: String
    var uploadDate: Date
    var distance: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case keywords
        case description
        case imageURLString
        case uploadDate
        case distance
    }
}

extension Place {
    static let dummy = Place(
        name: "카페 휙",
        keywords: ["따뜻한", "자유로운", "풋풋한"],
        description: "서툴지만 한걸음씩 따뜻하게",
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FLQXiQ1h77EJsmX7daDpG%2F0C3A8BDF-FD28-41BD-BA23-390A2171A1AD.jpeg?alt=media&token=ae61edda-71ee-4714-a0f8-1c000382f70e",
        uploadDate: Date(timeIntervalSinceNow: -5600),
        distance: 300
    )
}
