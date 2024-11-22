//
//  Facility.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/22/24.
//

import Foundation

enum Facility: Hashable {
    case lundry
    case convenienceStore
    case mart
    case hospital
    case pharmacy
    case park
    case daiso
    
    var keyword: String {
        switch self {
        case .lundry: return "빨래방"
        case .convenienceStore: return "편의점"
        case .mart: return "마트"
        case .hospital: return "병원"
        case .pharmacy: return "약국"
        case .park: return "공원"
        case .daiso: return "다이소"
        }
    }
    
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
