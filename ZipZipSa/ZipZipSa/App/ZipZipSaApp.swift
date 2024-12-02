//
//  ZipZipSaApp.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import SwiftData

@main
struct ZipZipSaApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self, ChecklistCategoryData.self, HomeData.self, RentalFeeData.self, LocationData.self, FacilityData.self, MemoData.self, HazardData.self], isAutosaveEnabled: true)
        }
    }
}
