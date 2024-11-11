//
//  FirestoreQueryOption.swift
//  Eggong
//
//  Created by YunhakLee on 10/18/24.
//

import Foundation

struct QueryOption {
    let field: String
    let operation: QueryOperation
    let value: Any
}

enum QueryOperation {
    case isEqualTo
    case isLessThan
    case isLessThanOrEqualTo
    case isGreaterThan
    case isGreaterThanOrEqualTo
    case arrayContains
}

