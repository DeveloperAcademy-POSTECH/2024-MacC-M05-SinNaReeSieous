//
//  ChecklistType.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/21/24.
//

import Foundation

enum ChecklistType {
    case quick
    case basic
    case advanced

    var text: String {
        switch self {
        case .quick: "빠르게"
        case .basic: "기본"
        case .advanced: "추가"
        }
    }
}
