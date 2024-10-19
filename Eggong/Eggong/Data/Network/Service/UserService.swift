//
//  UserService.swift
//  Eggong
//
//  Created by YunhakLee on 10/19/24.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage
import PhotosUI

protocol UserService: FirebaseFirestoreFoundation, FirebaseStorageFoundation {
    func getUser() async throws -> User
    func postUser(_ user: User, item: PhotosPickerItem) async throws
}

final class DefaultUserService: UserService {
    var db: Firestore = Firestore.firestore()
    var storage: Storage = Storage.storage()
    
    func getUser() async throws -> User {
        try await getDocument(
            path: StringLiterals.Network.userPath,
            documentID: StringLiterals.Network.dummyUserID,
            type: User.self)
    }
    
    func postUser(_ user: User, item: PhotosPickerItem) async throws {
        let id = StringLiterals.Network.dummyUserID
        _ = try await postDocument(
            path: StringLiterals.Network.userPath,
            id: id,
            data: user
        )
        
        let downloadURLString = try await postPhotosPickerItem(
            path: StringLiterals.Network.userImagePath(id: id),
            imageName: UUID().uuidString,
            item: item
        )

        try await putData(
            path: StringLiterals.Network.userPath,
            documentID: id,
            data: [User.CodingKeys.profileImageURLString.rawValue: downloadURLString]
        )
    }
}
