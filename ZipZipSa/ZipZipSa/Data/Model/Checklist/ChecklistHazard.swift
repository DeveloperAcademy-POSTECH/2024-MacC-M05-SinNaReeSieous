//
//  ChecklistHazard.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum Hazard: String, Hashable {
    case waterLeak
    case waterPressure
    case waterCold
    case waterDrainage
    case mold
    case noise
    case privacy
    case cockroach
    case cigaretteSmell
    
    var text: String {
        switch self {
        case .waterLeak: return "누수"
        case .waterPressure: return "수압"
        case .waterCold: return "온수"
        case .waterDrainage: return "배수"
        case .mold: return "곰팡이"
        case .noise: return "소음"
        case .privacy: return "사생활"
        case .cockroach: return "바퀴벌레"
        case .cigaretteSmell: return "담배"
        }
    }
}
