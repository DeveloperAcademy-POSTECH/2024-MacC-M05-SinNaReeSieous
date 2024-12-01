//
//  TestFacilityManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import Foundation
import MapKit

class FacilityManager {
    static func searchFacilities(
        at coordinate: CLLocationCoordinate2D,
        radius: Double = 500
    ) async throws -> [String: Bool] {
        var results: [String: Bool] = [:]
        let searchRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: radius * 2,
            longitudinalMeters: radius * 2
        )
        
        // TaskGroup을 사용하여 병렬로 검색
        try await withThrowingTaskGroup(of: (String, Bool).self) { group in
            for facility in Facility.allCases {
                group.addTask {
                    let request = MKLocalSearch.Request()
                    request.naturalLanguageQuery = facility.rawValue
                    request.region = searchRegion

                    let search = MKLocalSearch(request: request)
                    do {
                        let response = try await search.start()
                        
                        // 반경 내 필터링
                        let filteredItems = response.mapItems.filter { item in
                            if let location = item.placemark.location {
                                return location.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) <= radius
                            }
                            return false
                        }
                        return (facility.rawValue, !filteredItems.isEmpty)
                    } catch {
                        throw error
                    }
                }
            }
            
            // TaskGroup에서 결과를 받아 dictionary에 저장
            for try await (facility, isFound) in group {
                results[facility] = isFound
            }
        }
        
        return results
    }
}

