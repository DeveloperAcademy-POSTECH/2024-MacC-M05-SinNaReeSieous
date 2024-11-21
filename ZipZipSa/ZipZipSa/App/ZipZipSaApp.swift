//
//  ZipZipSaApp.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import GoogleMaps

@main
struct ZipZipSaApp: App {
    @State private var hasRoomModel: Bool = false
    init() {
        GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "API KEY를 가져오는데 실패했습니다.")
    }
    
    var body: some Scene {
        WindowGroup {
            RoomScanView(hasRoomModel: $hasRoomModel)
        }
    }
}
