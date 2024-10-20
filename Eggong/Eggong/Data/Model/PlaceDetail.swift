//
//  PlaceDetail.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

struct PlaceDetail: FirebaseCodable, Identifiable {
    var id: String?
    var name: String
    var keywords: [String]
    var imageURLString: String
    var makingStory: String
    var storyImageURLStrings: [String]
    var stories: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case keywords
        case imageURLString
        case makingStory
        case storyImageURLStrings
        case stories
    }
}
