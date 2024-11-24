//
//  ChecklistHazard.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum Hazard: Hashable {
    case waterLeak
    case waterPressure
    case waterCold
    case waterDrainage
    case mold
    case noise
    case privacy
    case cockroach
    
    var text: String {
        switch self {
        case .waterLeak: return "누수위험"
        case .waterPressure: return "수압위험"
        case .waterCold: return "온수위험"
        case .waterDrainage: return "배수위험"
        case .mold: return "곰팡이위험"
        case .noise: return "소음위험"
        case .privacy: return "사생활위험"
        case .cockroach: return "바퀴위험"
        }
    }
}
