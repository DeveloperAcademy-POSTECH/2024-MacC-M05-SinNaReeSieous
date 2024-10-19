//
//  StringLiterals.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import Foundation

enum StringLiterals {
    enum Network {
        // Place
        static let placePath = "Places"
        static func placeImagePath(id: String) -> String {
            return "\(placePath)/\(id)"
        }
        
        // PlaceDetail
        static let placeDetailPath = "PlaceDetails"
        static func placeDetailImagePath(id: String) -> String {
            return "\(placeDetailPath)/\(id)"
        }
        
        //User
        static let userPath = "Users"
        static let dummyUserID = "262179B1-2AD6-416B-9323-E62C5A19D0A9"
        static func userImagePath(id: String) -> String {
            return "\(userPath)/\(id)"
        }
    }
}
