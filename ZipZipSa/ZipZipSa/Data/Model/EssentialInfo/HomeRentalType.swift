//
//  HomeRentalType.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import Foundation

enum HomeRentalType: CaseIterable {
    case monthlyRent
    case fullDeposit
    case semiDeposit
    
    var text: String {
        switch self {
        case .monthlyRent: return "월세"
        case .fullDeposit: return "전세"
        case .semiDeposit: return "반전세"
        }
    }
}