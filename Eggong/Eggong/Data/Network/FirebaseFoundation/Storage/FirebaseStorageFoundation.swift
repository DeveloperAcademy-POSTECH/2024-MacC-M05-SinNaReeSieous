//
//  FirebaseStorageFoundation.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

protocol FirebaseStorageFoundation {
    var storage: Storage { get set }
    func postUIImage(path: String, imageName: String, _ image: UIImage?) async throws -> String
    func postData(path: String, data: Data) async throws -> String
    func postPhotosPickerItem(path: String, imageName: String, _ item: PhotosPickerItem) async throws -> String
}

extension FirebaseStorageFoundation {
    func postUIImage(path: String, imageName: String, _ image: UIImage?) async throws -> String {
        guard let image else {
            throw FirebaseError.dataNotFound
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseError.encodingFailed
        }
        
        let imagePath = "\(path)/\(imageName).jpg"
        return try await postData(path: imagePath, data: imageData)
    }
    
    func postPhotosPickerItem(path: String, imageName: String, _ item: PhotosPickerItem) async throws -> String {
        guard let data = try? await item.loadTransferable(type: Data.self) else {
            throw FirebaseError.encodingFailed
        }
        
        let imagePath = "\(path)/\(imageName).jpg"
        return try await postData(path: imagePath, data: data)
    }
    
    func postData(path: String, data: Data) async throws -> String {
        let dataRef = storage.reference(withPath: path)
        
        do {
            _ = try await dataRef.putDataAsync(data)
            let downloadURLString = try await self.getStorageURLString(path: path)
            FirebaseLogger.log(success: .postImage(downloadURLString: downloadURLString))
            return downloadURLString
        } catch {
            throw FirebaseError.firebaseMethodFailed
        }
    }
    
    func getStorageURLString(path: String?) async throws -> String {
        guard let path else {
            throw FirebaseError.invalidPath
        }
        
        guard let url = try? await storage.reference(withPath: path).downloadURL() else {
            throw FirebaseError.firebaseMethodFailed
        }
        
        return url.absoluteString
    }
}
