//
//  Sheet.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import Foundation

enum Sheet: Identifiable, Hashable {
    
    var id: Self { self }
    
    // 에센셜인포
    case addressEnter
    
    // 결과카드
    case resultCard
    case resultDetails
}
