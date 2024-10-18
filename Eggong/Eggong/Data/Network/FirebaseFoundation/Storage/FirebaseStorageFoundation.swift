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
    func postPhotosPickerItem(path: String, imageName: String, item: PhotosPickerItem) async throws -> String
    func postPhotosPickerItems(path: String, imageName: String, items: [PhotosPickerItem]) async throws -> [String]
}

extension FirebaseStorageFoundation {
    
    /// UIImagePicker를 사용할 때 사용하기 편하게 이미지를 업로드 할 수 있다.
    func postUIImage(path: String, imageName: String, image: UIImage?) async throws -> String {
        guard let image else {
            throw FirebaseError.dataNotFound
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseError.encodingFailed
        }
        
        let imagePath = "\(path)/\(imageName).jpg"
        return try await postData(path: imagePath, data: imageData)
    }
    
    /// SwiftUI용으로 새로 나온 PhotosPicker 를 사용할 때 편하게 이미지를 업로드 할 수 있는 함수
    func postPhotosPickerItem(path: String, imageName: String, item: PhotosPickerItem) async throws -> String {
        guard let data = try? await item.loadTransferable(type: Data.self) else {
            throw FirebaseError.encodingFailed
        }
        
        let imagePath = "\(path)/\(imageName).jpg"
        return try await postData(path: imagePath, data: data)
    }
    
    /// 여러 PhotosPickerItem을 동시에 업로드 할때. post 코드는 병렬로 호출되어서 동시에 진행된다.
    func postPhotosPickerItems(path: String, imageName: String, items: [PhotosPickerItem]) async throws -> [String] {
        var results = Array(repeating: "", count: items.count)
        
        try await withThrowingTaskGroup(of: (Int, String).self) { group in
            for (index, item) in items.enumerated() {
                group.addTask {
                    let url = try await postPhotosPickerItem(path: path, imageName: imageName, item: item)
                    return (index, url)
                }
            }
            
            for try await (index, url) in group {
                results[index] = url
            }
        }
        
        return results
    }
    
    /// 범용적으로 Data 타입의 값을 업로드 할 수 있는 함수, 다른 메서드를 위한 기초 함수. 다운로드 URL을 반환한다.
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
    
    /// 다운로드 URL을 String 타입으로 반환받는 메서드
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
