//
//  Screen.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import Foundation

enum Screen: Identifiable, Hashable {
    
    var id: Self { self }
    
    // 온보딩
    case onboarding
    case categorySelect
    
    // 메인
    case main
    
    // 에센셜인포
    case essentialsInfo
    
    // 체크리스트
    case checkList
    
    // 룸스캔
    case roomScanInfo
    case unsupportedDevice
    case roomScan
    
    // 홈리스트
    case homeList
    
    // 세팅
    case setting
    case categoryChange
    case privacyPolicy
}
