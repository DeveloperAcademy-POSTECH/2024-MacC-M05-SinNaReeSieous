//
//  Untitled.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/23/24.
//

import Foundation

struct AutocompleteResponse: Codable {
    struct Prediction: Codable {
        let description: String
        let place_id: String
    }
    let predictions: [Prediction]
}

struct PlaceDetailsResponse: Codable {
    struct Result: Codable {
        let geometry: Geometry
    }
    let result: Result
}

struct PlacesResponse: Codable {
    let results: [PlaceResult]
}

// MARK: - 공통 사용 구조체
struct PlaceResult: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
