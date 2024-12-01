//
//  Facility.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/22/24.
//

import Foundation

enum Facility: String, Hashable, CaseIterable {
    case lundry = "세탁소"
    case convenienceStore = "편의점"
    case mart = "마트"
    case hospital = "병원"
    case pharmacy = "약국"
    case park = "공원"
    case daiso = "다이소"
    
    var icon: String {
        switch self {
        case .lundry: return "washer.circle.fill"
        case .convenienceStore: return "24.circle.fill"
        case .mart: return "cart.circle.fill"
        case .hospital: return "cross.case.circle.fill"
        case .pharmacy: return "pill.circle.fill"
        case .park: return "tree.circle.fill"
        case .daiso: return "daiso.circle.fill"
        }
    }
}
