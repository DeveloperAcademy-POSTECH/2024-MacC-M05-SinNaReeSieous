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
    static let dummy1 = Place(
        id: "ANSi11G77ESskX7d4s2S",
        name: "카페 낙원",
        keywords: ["따뜻한", "강아지", "철길숲"],
        description: "햇살과 숲 사이에서 평온한 시간을 머금는 작은 천국",
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FANSi11G77ESskX7d4s2S%2F20F1EC9C-DEAA-4EE2-890A-805FB199EDF0.jpeg?alt=media&token=f33663f7-b078-4347-88a3-3e32a3225873",
        uploadDate: Date(timeIntervalSinceNow: -100000),
        distance: 1500
    )
    
    static let dummy2 = Place(
        id: "BQXiQ1h77E2skX7daDpG",
        name: "Track.3",
        keywords: ["빛", "동물친구", "붉은벽돌집"],
        description: "Anyone, Everyone is Always Welcome! ● ● ●",
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FBQXiQ1h77E2skX7daDpG%2FC3F88490-6A6D-4E15-B8FF-03AE63ADD49D.png?alt=media&token=32ffe6c5-b74c-43b2-9d20-8b319ca0a5f1",
        uploadDate: Date(timeIntervalSinceNow: -10000),
        distance: 700
    )
    
    static let dummy3 = Place(
        id: "J4TRZmkvNbUqPM9xT2NVOa6DZrw4",
        name: "카페 휙",
        keywords: ["따뜻한", "자유로운", "풋풋한"],
        description: "서툴지만 한걸음씩 따뜻하게",
        imageURLString: "https://firebasestorage.googleapis.com/v0/b/macc-eggong.appspot.com/o/Places%2FLQXiQ1h77EJsmX7daDpG%2F0C3A8BDF-FD28-41BD-BA23-390A2171A1AD.jpeg?alt=media&token=ae61edda-71ee-4714-a0f8-1c000382f70e",
        uploadDate: Date(timeIntervalSinceNow: -5600),
        distance: 300
    )
}
