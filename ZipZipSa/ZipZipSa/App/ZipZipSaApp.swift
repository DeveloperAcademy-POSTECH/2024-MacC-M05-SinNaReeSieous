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
    
    var modelContainer: ModelContainer = {
        let schema = Schema([User.self, ChecklistCategoryData.self])
           let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
           
           do {
               return try ModelContainer(for: schema, configurations: [modelConfiguration])
           } catch {
               fatalError("Could not create ModelContainer: \(error)")
           }
       }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
