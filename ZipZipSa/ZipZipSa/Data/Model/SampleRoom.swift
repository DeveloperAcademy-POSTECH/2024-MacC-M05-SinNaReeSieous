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
    @Attribute(.externalStorage) var mainPictureData: Data?
    @Attribute(.externalStorage) var model: Data?
    var latitude: Double
    var longitude: Double
    
    init(id: UUID, mainPicture: UIImage?, model: Data, latitude: Double, longitude: Double) {
        self.id = id
        self.mainPictureData = mainPicture?.pngData()
        self.model = model
        self.latitude = latitude
        self.longitude = longitude
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
