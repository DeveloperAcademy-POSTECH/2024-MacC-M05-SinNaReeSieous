//
//  FirebaseModelProtocol.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

// MARK: - FirebaseFirestore
protocol FirebaseEncodable: Encodable {
    var id: String? { get set }
}

protocol FirebaseCodable: FirebaseEncodable, Decodable {
    
}

