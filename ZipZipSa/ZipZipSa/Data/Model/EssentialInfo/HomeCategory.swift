//
//  HomeCategory.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import Foundation

enum HomeCategory: CaseIterable {
    case mutiUnitHouse
    case villa
    case officetel
    
    var text: String {
        switch self {
        case .mutiUnitHouse: return "주택"
        case .villa: return "빌라"
        case .officetel: return "오피스텔"
        }
    }
}
