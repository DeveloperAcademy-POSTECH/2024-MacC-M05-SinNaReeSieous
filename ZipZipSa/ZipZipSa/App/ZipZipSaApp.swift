//
//  ZipZipSaApp.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData
import GoogleMaps

@main
struct ZipZipSaApp: App {
    init() {
        GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }
    }
}
