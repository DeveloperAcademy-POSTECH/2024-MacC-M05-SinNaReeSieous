//
//  PlaceService.swift
//  Eggong
//
//  Created by YunhakLee on 10/17/24.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage
import PhotosUI

protocol PlaceService: FirebaseFirestoreFoundation, FirebaseStorageFoundation {
    func getPlaces() async throws -> [Place]
    func postPlace(_ place: Place, item: PhotosPickerItem) async throws -> String
}

final class DefaultPlaceService: PlaceService {
    var db: Firestore = Firestore.firestore()
    var storage: Storage = Storage.storage()
    
    func getPlaces() async throws -> [Place] {
        try await getDocuments(path: StringLiterals.Network.placePath,
                               type: Place.self)
    }
    
    func postPlace(_ place: Place, item: PhotosPickerItem) async throws -> String {
        let documentID = try await postDocument(
            path: StringLiterals.Network.placePath,
            data: place
        )

        let imageName = UUID().uuidString
        let downloadURLString = try await postPhotosPickerItem(
            path: StringLiterals.Network.placeImagePath(id: documentID),
            imageName: imageName,
            item: item
        )

        try await putData(
            path: StringLiterals.Network.placePath,
            documentID: documentID,
            data: [Place.CodingKeys.imageURLString.rawValue: downloadURLString]
        )
        
        return documentID
    }
}
