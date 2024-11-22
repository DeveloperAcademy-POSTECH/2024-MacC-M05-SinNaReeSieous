//
//  FacilityChecker.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/21/24.
//

import Foundation
import CoreLocation

struct FacilityChecker {
    let apiKey: String
    let radius: Int = 350
    
    func checkFacilities(at location: CLLocationCoordinate2D, for keywords: [String], completion: @escaping ([String: Bool]) -> Void) {
        var results: [String: Bool] = [:]
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.facilitychecker.queue")
        
        for keyword in keywords {
            group.enter()
            
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&keyword=\(keyword)&key=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL for keyword: \(keyword)")
                results[keyword] = false
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if let error = error {
                    print("Error fetching data for \(keyword): \(error.localizedDescription)")
                    queue.sync { results[keyword] = false }
                    return
                }
                
                guard let data = data else {
                    print("No data for keyword: \(keyword)")
                    queue.sync { results[keyword] = false }
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON for \(keyword): \(jsonString)")
                }
                
                do {
                    let decoded = try JSONDecoder().decode(PlacesResponse.self, from: data)
                    let filteredResults = decoded.results.filter {
                        isWithinRadius(center: location, location: $0.geometry.location, radius: radius)
                    }
                    queue.sync { results[keyword] = !filteredResults.isEmpty }
                } catch {
                    print("Decoding error for \(keyword): \(error.localizedDescription)")
                    queue.sync { results[keyword] = false }
                }
            }.resume()
            
        }
        
        group.notify(queue: .main) {
            completion(results)
        }
    }
}

struct PlacesResponse: Codable {
    let results: [Place]
}

struct Place: Codable {
    let name: String
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

func isWithinRadius(center: CLLocationCoordinate2D, location: Location, radius: Int) -> Bool {
    let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    let targetLocation = CLLocation(latitude: location.lat, longitude: location.lng)
    return centerLocation.distance(from: targetLocation) <= Double(radius)
}
