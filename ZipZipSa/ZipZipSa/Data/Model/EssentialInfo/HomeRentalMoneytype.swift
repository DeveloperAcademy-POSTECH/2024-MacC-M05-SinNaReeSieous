//
//  HomeRentalMoneytype.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//
//

import Foundation

enum HomeRentalMoneytype: Hashable {
    case deposit
    case monthlyFee
    case managementFee
    
    var text: String {
        switch self {
        case .deposit: return "보증금"
        case .monthlyFee: return "월세"
        case .managementFee: return "관리비"
        }
    }
    
    var index: [Int] {
        switch self {
        case .deposit: return [0, 1]
        case .monthlyFee: return [2]
        case .managementFee: return [3]
        }
    }
}
