//
//  PathModel+.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import SwiftUI

extension PathModel {
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .main:
            MainView()
        case .setting:
            SettingView()
        case .onboarding:
            OnboardingView()
        case .categorySelect:
            CategorySelectView()
        case .essentialsInfo:
            EssentialInfoView()
        case .checkList:
            ChecklistView()
        case .roomScanInfo:
            RoomScanInfoView()
        case .unsupportedDevice:
            UnsupportedDeviceView()
        case .roomScan:
            RoomScanView()
        case .homeList:
            HomeListView()
        case .categoryChange:
            CategoryChangeView()
        case .privacyPolicy:
            PrivacyPolicyView()
        }
    }
}
