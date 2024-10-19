//
//  FirebaseFirestoreFoundation.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import SwiftUI
import FirebaseFirestore

protocol FirebaseFirestoreFoundation {
    
    var db: Firestore { get set }
    
    // Encoding & Decoding
    func decode<T: Decodable>(
        type: T.Type,
        data: [String: Any]
    ) throws -> T
    
    func encode<T: Encodable>(
        data: T
    ) throws -> [String: Any]
    
    // Get(조회)
    func getDocument<T: Decodable>(
        path: String,
        documentID: String?,
        type: T.Type
    ) async throws -> T
    
    func getDocuments<T: Decodable>(
        path: String,
        type: T.Type,
        queryOptions: [QueryOption],
        sortOptions: [SortOption],
        limit: Int?
    ) async throws -> [T]
    
    // Post(생성)
    func postDocument<T: FirebaseEncodable>(
        path: String,
        id: String?,
        data: T
    ) async throws -> String
    
    // Put(수정)
    func putDocument<T: FirebaseEncodable>(
        path: String,
        data: T
    ) async throws
    
    func putData(
        path: String,
        documentID: String?,
        data: [String: Any]
    ) async throws
    
    // Delete(삭제)
    func deleteDocument(
        path: String,
        documentID: String?
    ) async throws
    
    func deleteFields(
        path: String,
        documentID: String?,
        fieldKeys: [String]
    ) async throws
}

extension FirebaseFirestoreFoundation {
    
    // Encoding & Decoding
    func decode<T: Decodable>(
        type: T.Type,
        data: [String: Any]
    ) throws -> T {
        guard let result = try? Firestore.Decoder().decode(T.self, from: data) else {
            throw FirebaseError.decodingFailed
        }
        return result
    }
    
    func encode<T: Encodable>(
        data: T
    ) throws -> [String: Any] {
        guard let result = try? Firestore.Encoder().encode(data) else {
            throw FirebaseError.encodingFailed
        }
        return result
    }
    
    // MARK: - Get(조회)
    
    /// 단일 document 조회
    func getDocument<T: Decodable>(
        path: String,
        documentID: String?,
        type: T.Type
    ) async throws -> T {
        guard let documentID else {
            throw FirebaseError.invalidPath
        }
        
        let docRef = db.collection(path).document(documentID)
        
        guard let document = try? await docRef.getDocument() else {
            throw FirebaseError.firebaseMethodFailed
        }
        
        guard let data = document.data() else {
            throw FirebaseError.documentNotFound
        }
        
        let result = try self.decode(type: type, data: data)
        
        FirebaseLogger.log(success: .getDocument(data: String(describing: result)))
        
        return result
    }
    
    /// 컬렉션 조회 (쿼리 & 정렬)
    func getDocuments<T: Decodable>(
        path: String,
        type: T.Type,
        queryOptions: [QueryOption] = [],
        sortOptions: [SortOption] = [],
        limit: Int? = nil
    ) async throws -> [T] {
        var query: Query = db.collection(path)
        
        // 쿼리 적용
        for option in queryOptions {
            switch option.operation {
            case .isEqualTo:
                query = query.whereField(option.field, isEqualTo: option.value)
            case .isLessThan:
                query = query.whereField(option.field, isLessThan: option.value)
            case .isLessThanOrEqualTo:
                query = query.whereField(option.field, isLessThanOrEqualTo: option.value)
            case .isGreaterThan:
                query = query.whereField(option.field, isGreaterThan: option.value)
            case .isGreaterThanOrEqualTo:
                query = query.whereField(option.field, isGreaterThanOrEqualTo: option.value)
            case .arrayContains:
                query = query.whereField(option.field, arrayContains: option.value)
            }
        }
        
        // 정렬 적용
        for sort in sortOptions {
            query = query.order(by: sort.field, descending: sort.descending)
        }
        
        // 개수 제한 적용
        if let limit {
            query = query.limit(to: limit)
        }
        
        guard let snapshot = try? await query.getDocuments() else {
            throw FirebaseError.firebaseMethodFailed
        }
        
        var results: [T] = []
        for document in snapshot.documents {
            let data = document.data()
            let result = try self.decode(type: type, data: data)
            results.append(result)
        }
        
        FirebaseLogger.log(success: .getDocuments(count: results.count))
        
        return results
    }
    
    // MARK: - Post(생성)
    
    /// 컬렉션에 document를 만들어 데이터를 추가하고, 해당 documentID를 반환한다.
    func postDocument<T: FirebaseEncodable>(
        path: String,
        id: String? = nil,
        data: T
    ) async throws -> String {
        let colRef = db.collection(path)
        let documentID = id ?? colRef.document().documentID
        var targetData = data
        targetData.id = documentID
        
        let encodedData = try self.encode(data: targetData)

        do {
            try await colRef.document(documentID).setData(encodedData)
            FirebaseLogger.log(success: .postDocument(id: documentID))
            return documentID
        } catch {
            throw FirebaseError.firebaseMethodFailed
        }
    }
    
    // MARK: - Put(수정)
    
    /// 구조체 전체를 put하는데 사용할 때
    func putDocument<T: FirebaseEncodable>(
        path: String,
        data: T
    ) async throws {
        guard let documentID = data.id else {
            throw FirebaseError.invalidPath
        }
        let encodedData = try self.encode(data: data)
        try await self.putData(path: path,
                               documentID: documentID,
                               data: encodedData)
        FirebaseLogger.log(success: .putDocument(data: String(describing: data)))
    }
    
    /// put할 때 일부 데이터만 알고 있어서 전체 구조체를 보내지 못하는 경우
    func putData(
        path: String,
        documentID: String?,
        data: [String: Any]
    ) async throws {
        guard let documentID else {
            throw FirebaseError.invalidPath
        }
        
        let docRef = db.collection(path).document(documentID)

        do {
            try await docRef.updateData(data)
            FirebaseLogger.log(success: .putData(data: String(describing: data)))
        } catch {
            throw FirebaseError.firebaseMethodFailed
        }
    }
    
    // MARK: - Delete
    
    /// document 하나를 통째로 삭제할 때
    func deleteDocument(
        path: String,
        documentID: String?
    ) async throws {
        guard let documentID else {
            throw FirebaseError.invalidPath
        }
        
        do {
            try await db.collection(path).document(documentID).delete()
            FirebaseLogger.log(success: .deleteDocument(documentID: documentID))
        } catch {
            throw FirebaseError.firebaseMethodFailed
        }
    }
    
    /// 해당 document의 필드 일부를 삭제할 때
    func deleteFields(
        path: String,
        documentID: String?,
        fieldKeys: [String]
    ) async throws {
        guard let documentID else {
            throw FirebaseError.invalidPath
        }
        
        do {
            for fieldKey in fieldKeys {
                async let _ = try db.collection(path).document(documentID).updateData([fieldKey:FieldValue.delete()])
            }
            FirebaseLogger.log(success: .deleteFields(fieldKeys: fieldKeys))
        } catch {
            throw FirebaseError.firebaseMethodFailed
        }
    }
}

// MARK: - Todo - 변경사항만 가져오기 구현. (실시간 리스너를 하면 배터리 소모도 빠르고 자원 소모도 지속적으로 있어서, 채팅앱같이 실시간이 중요하지 않은 이상 안쓰는게 좋은 듯 해서..)
// updatedAt: TimeStamp를 필드에 추가하고, 이 값과 로컬의 API 요청 타임 스탬프를 비교하면 최근 추가된 변경사항만 찾을 수 있다 . .
//    func fetchDocuments<T>(type: T.Type, path: String) async throws -> (added: [T], removed: [T], modified: [T]) where T: Decodable {
//        var added: [T] = []
//        var removed: [T] = []
//        var modified: [T] = []
//
//        let docRef = db.collection(path)
//        guard let snapshot = try? await docRef.getDocuments() else {
//            throw FirebaseError.serverConnectionFailed
//        }
//
//        try snapshot.documentChanges.forEach { documentChange in
//            let data = documentChange.document.data()
//            let result = try self.decode(type: type, data: data)
//
//            switch documentChange.type {
//            case .added:
//                added.append(result)
//            case .modified:
//                modified.append(result)
//            case .removed:
//                removed.append(result)
//            }
//        }
//
//        print("=======SUCCESS:fetchDocuments=======\nAddedDocuments Count: \(added.count)\nModifiedDocuments Count: \(modified.count)\nRemovedDocuments Count: \(removed.count)")
//
//        return (added, removed, modified)
//    }
