//
//  FirebaseError.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

enum FirebaseError: Error, CustomStringConvertible {
    case encodingFailed
    case decodingFailed
    case invalidPath
    case dataNotFound
    case documentNotFound
    case firebaseMethodFailed
    
    var description: String {
        switch self {
        case .encodingFailed:
            return "=======ERROR:Encoding failed======="
        case .decodingFailed:
           return "=======ERROR:decoding failed======="
        case .invalidPath:
            return "=======ERROR:Invalid path======="
        case .documentNotFound:
            return "=======ERROR:Document not found======="
        case .firebaseMethodFailed:
            return "=======ERROR:Server connection failed======="
        case .dataNotFound:
            return "=======ERROR:Data not found======="
        }
    }
}
