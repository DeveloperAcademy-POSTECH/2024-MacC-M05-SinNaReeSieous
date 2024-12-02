//
//  SampleRoom.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI
import SwiftData

@Model
final class SampleRoom {
    var id: UUID
    @Attribute(.externalStorage) var mainPictureData: Data?
    @Attribute(.externalStorage) var model: Data?
    var latitude: Double
    var longitude: Double
    var availableFacilities: [String]

    init(id: UUID = UUID(), mainPicture: UIImage? = nil, model: Data? = nil, latitude: Double, longitude: Double, availableFacilities: [Facility] = []) {
        self.id = id
        self.mainPictureData = mainPicture?.pngData()
        self.model = model
        self.latitude = latitude
        self.longitude = longitude
        self.availableFacilities = availableFacilities.map { $0.rawValue }
    }
    
    var facilities: [Facility] {
        availableFacilities.compactMap { Facility(rawValue: $0) }
    }
    
    // UIImage를 가져오기 위한 computed property
    var mainPicture: UIImage? {
        get {
            guard let data = mainPictureData else { return nil }
            return UIImage(data: data)
        }
        set {
            mainPictureData = newValue?.pngData()
        }
    }
}
