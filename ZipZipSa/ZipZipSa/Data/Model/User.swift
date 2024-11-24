//
//  User.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI
import SwiftData

@Model
final class User {
    var id: UUID
    var favoriteLatitude: Double
    var favoriteLongitude: Double
    
    init(favoriteLatitude: Double, favoriteLongitude: Double) {
        self.id = UUID()
        self.favoriteLatitude = favoriteLatitude
        self.favoriteLongitude = favoriteLongitude
    }
}
