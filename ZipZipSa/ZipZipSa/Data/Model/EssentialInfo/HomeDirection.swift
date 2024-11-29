//
//  HomeDirection.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import Foundation

enum HomeDirection: String, CaseIterable {
    case east
    case west
    case south
    case north
    
    var text: String {
        switch self {
        case .east: return "동향"
        case .west: return "서향"
        case .south: return "남향"
        case .north: return "북향"
        }
    }
}
