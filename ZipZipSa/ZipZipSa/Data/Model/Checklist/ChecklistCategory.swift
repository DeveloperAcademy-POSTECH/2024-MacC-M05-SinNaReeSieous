//
//  ChecklistCategory.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum ChecklistCategory: String, CaseIterable, Hashable {
    case insectproof
    case cleanliness
    case security
    case ventilation
    case sunlight
    case soundproof
    case environment
    case facilities
    
    var text: String {
        switch self {
        case .insectproof: return "방충"
        case .cleanliness: return "청결"
        case .security: return "치안"
        case .ventilation: return "환기"
        case .sunlight: return "채광"
        case .soundproof: return "방음"
        case .environment: return "실내환경"
        case .facilities: return "공용시설 및 음선"
        }
    }
    
    var isSelectable: Bool {
        switch self {
        case .insectproof, .cleanliness, .security, .ventilation, .sunlight, .soundproof: return true
        case .environment, .facilities: return false
        }
    }
}
