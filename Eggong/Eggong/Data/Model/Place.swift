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
