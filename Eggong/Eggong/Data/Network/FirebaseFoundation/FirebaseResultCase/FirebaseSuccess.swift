//
//  FirebaseSuccess.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

enum FirebaseSuccess: CustomStringConvertible {
    case getDocument(data: String)
    case getDocuments(count: Int)
    
    case postDocument(id: String)
    
    case putDocument(data: String)
    case putData(data: String)
    
    case deleteDocument(documentID: String)
    case deleteFields(fieldKeys: [String])
    
    case postImage(downloadURLString: String)
    
    var description: String {
        switch self {
        case .getDocument(let data):
            return "=======SUCCESS:GetDocument=======\nNew Document data: \(data)"
        case .getDocuments(let count):
            return "=======SUCCESS:GetDocuments=======\nNew Documents Count: \(count)"
        case .postDocument(let id):
            return "=======SUCCESS:PostDocument=======\nCreated Document ID: \(id)"
        case .putDocument(data: let data):
            return "=======SUCCESS:PutDocument=======\nUpdated Document data: \(data)"
        case .putData(data: let data):
            return "=======SUCCESS:PutData=======\nUpdated Document data: \(data)"
        case .deleteDocument(documentID: let documentID):
            return "=======SUCCESS:DeleteDocument=======\nDeleted Document ID: \(documentID)"
        case .deleteFields(fieldKeys: let fieldKeys):
            return "=======SUCCESS:DeleteFields=======\nDeleted Field Keys: \(fieldKeys)"
        case .postImage(downloadURLString: let downloadURLString):
            return "=======SUCCESS:PostImage=======\nPosted Image URL: \(downloadURLString)"
        }
    }
}
