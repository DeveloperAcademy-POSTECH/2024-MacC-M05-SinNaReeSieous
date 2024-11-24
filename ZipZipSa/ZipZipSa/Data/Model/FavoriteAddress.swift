//
//  FavoriteAddress.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI
import SwiftData

@Model
final class FavoriteAddress {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
