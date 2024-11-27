//
//  FacilityChecker.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/21/24.
//

import Foundation
import CoreLocation

class FacilityChecker {
    static let shared = FacilityChecker()
    
    private let apiKey: String
    private let radius: Int = 350
    
    private init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
    
    func checkFacilities(at location: CLLocationCoordinate2D, for keywords: [String]) async throws -> [String: Bool] {
        var results: [String: Bool] = [:]
        
        // TaskGroup을 사용하여 병렬로 여러 키워드를 처리
        try await withThrowingTaskGroup(of: (String, Bool).self) { group in
            for keyword in keywords {
                group.addTask {
                    let isFound = try await self.checkFacility(at: location, for: keyword)
                    return (keyword, isFound)
                }
            }
            
            // TaskGroup에서 결과를 받아서 dictionary에 저장
            for try await (keyword, isFound) in group {
                results[keyword] = isFound
            }
        }
        
        return results
    }


    private func checkFacility(at location: CLLocationCoordinate2D, for keyword: String) async throws -> Bool {
        let urlString = ZipLiteral.APIEndpoints.nearbySearch(latitude: location.latitude, longitude: location.longitude, radius: radius, keyword: keyword, apiKey: apiKey).url
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(keyword: keyword)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PlacesResponse.self, from: data)
            let filteredResults = decoded.results.filter {
                self.isWithinRadius(center: location, location: $0.geometry.location, radius: self.radius)
            }
            return !filteredResults.isEmpty
        } catch let error as URLError {
            throw NetworkError.networkError(keyword: keyword, description: error.localizedDescription)
        } catch let error {
            throw NetworkError.decodingError(keyword: keyword, description: error.localizedDescription)
        }
    }

    private func isWithinRadius(center: CLLocationCoordinate2D, location: Location, radius: Int) -> Bool {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let targetLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return centerLocation.distance(from: targetLocation) <= Double(radius)
    }
}
