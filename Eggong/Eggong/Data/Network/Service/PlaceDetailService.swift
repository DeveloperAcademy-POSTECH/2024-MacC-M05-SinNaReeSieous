//
//  PlaceDetailService.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage
import PhotosUI

protocol PlaceDetailService: FirebaseFirestoreFoundation, FirebaseStorageFoundation {
    func getPlaceDetail(id: String?) async throws -> PlaceDetail
    func postPlaceDetail(_ placeDetail: PlaceDetail, placeID: String?, items: [PhotosPickerItem]) async throws 
}

final class DefaultPlaceDetailService: PlaceDetailService {
    var db: Firestore = Firestore.firestore()
    var storage: Storage = Storage.storage()
    
    func getPlaceDetail(id: String?) async throws -> PlaceDetail {
        try await getDocument(path: StringLiterals.Network.placeDetailPath,
                              documentID: id,
                              type: PlaceDetail.self)
    }
    
    func postPlaceDetail(_ placeDetail: PlaceDetail, placeID: String?, items: [PhotosPickerItem]) async throws {
        guard items.count == 3 else {
            print("Please select 3 images.")
            return
        }
        
        guard let placeID else {
            throw FirebaseError.invalidPath
        }
        
        _ = try await postDocument(
            path: StringLiterals.Network.placeDetailPath,
            id: placeID,
            data: placeDetail
        )
        
        let imageNames = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let downloadURLStrings = try await postPhotosPickerItems(
            path: StringLiterals.Network.placeDetailImagePath(id: placeID) ,
            imageNames: imageNames,
            items: items
        )
        
        try await putData(
            path: StringLiterals.Network.placeDetailPath,
            documentID: placeID,
            data: [PlaceDetail.CodingKeys.storyImageURLStrings.rawValue: downloadURLStrings]
        )
    }
}
