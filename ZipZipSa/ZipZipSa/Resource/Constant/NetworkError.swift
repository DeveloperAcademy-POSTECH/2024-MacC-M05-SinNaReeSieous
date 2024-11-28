//
//  NetworkError.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/23/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL(keyword: String)
    case noData(keyword: String)
    case networkError(keyword: String, description: String)
    case decodingError(keyword: String, description: String)
    
    func logError() {
        switch self {
        case .invalidURL(let keyword):
            print("Invalid URL for keyword: \(keyword)")
        case .noData(let keyword):
            print("No data for keyword: \(keyword)")
        case .networkError(let keyword, let description):
            print("Network error for \(keyword): \(description)")
        case .decodingError(let keyword, let description):
            print("Decoding error for \(keyword): \(description)")
        }
    }
    
    enum AddressSearchError: Error {
        case invalidURL
        case noResults
        case networkError(description: String)
    }
}
