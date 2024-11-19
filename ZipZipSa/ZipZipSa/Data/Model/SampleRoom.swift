//
//  SampleRoom.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI
import SwiftData

// TODO: Room model 구조 확정된 이후 수정예정
@Model
final class SampleRoom: Identifiable {
    var id: UUID
    var date: String
    @Attribute(.externalStorage) var model: Data?
    var latitude: Double
    var longitude: Double
    
    init(id: UUID, date: String, model: Data, latitude: Double, longitude: Double) {
        self.id = id
        self.date = date
        self.model = model
        self.latitude = latitude
        self.longitude = longitude
    }
}
