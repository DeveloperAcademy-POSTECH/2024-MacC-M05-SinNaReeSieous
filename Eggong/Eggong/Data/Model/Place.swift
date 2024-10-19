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
    var uploadDate: String
    var imageURLString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case keywords
        case description
        case uploadDate
        case imageURLString
    }
}
