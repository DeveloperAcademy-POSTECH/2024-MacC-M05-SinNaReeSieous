//
//  SpaceType.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum SpaceType: CaseIterable {
    case exterior
    case livingRoom
    case window
    case kitchen
    case toilet
    
    var text: String {
        switch self {
        case .exterior: return "외부"
        case .livingRoom: return "거실 및 현관"
        case .window: return "창문"
        case .kitchen: return "주방"
        case .toilet: return "화장실"
        }
    }
}

struct Space {
    let type: SpaceType
    let questionNumber: Int
}
