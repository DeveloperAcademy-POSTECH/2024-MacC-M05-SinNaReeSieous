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
    
    func checkFacilities(at location: CLLocationCoordinate2D, for keywords: [String], completion: @escaping ([String: Bool]) -> Void) {
        var results: [String: Bool] = [:]
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.facilitychecker.queue")
        
        for keyword in keywords {
            group.enter()
            
            fetchFacility(for: keyword, at: location) { isFound in
                queue.sync { results[keyword] = isFound }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    private func fetchFacility(for keyword: String, at location: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for keyword: \(keyword)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data for \(keyword): \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data for keyword: \(keyword)")
                completion(false)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON for \(keyword): \(jsonString)")
            }
            
            do {
                let decoded = try JSONDecoder().decode(PlacesResponse.self, from: data)
                let filteredResults = decoded.results.filter {
                    self.isWithinRadius(center: location, location: $0.geometry.location, radius: self.radius)
                }
                completion(!filteredResults.isEmpty)
            } catch {
                print("Decoding error for \(keyword): \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    private func isWithinRadius(center: CLLocationCoordinate2D, location: Location, radius: Int) -> Bool {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let targetLocation = CLLocation(latitude: location.lat, longitude: location.lng)
        return centerLocation.distance(from: targetLocation) <= Double(radius)
    }
}
