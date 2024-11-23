//
//  Untitled.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/23/24.
//

import Foundation

struct PlacesResponse: Codable {
    let results: [PlaceResult]
}

struct PlaceResult: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
