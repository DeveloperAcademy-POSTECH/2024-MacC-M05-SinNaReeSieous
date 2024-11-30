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
        case .waterLeak: return "누수 위험"
        case .waterPressure: return "수압 안좋음"
        case .waterCold: return "온수 잘 안 나옴"
        case .waterDrainage: return "배수 안좋음"
        case .mold: return "곰팡이 위험"
        case .noise: return "소음 위험"
        case .privacy: return "사생활 위험"
        case .cockroach: return "바퀴 위험"
        case .cigaretteSmell: return "담배 위험"
        }
    }
}
