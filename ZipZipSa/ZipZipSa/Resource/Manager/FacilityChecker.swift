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
                if let error = error {
                    print("Error fetching data for \(keyword): \(error)")
                    results[keyword] = false
                } else if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(PlacesResponse.self, from: data)
                        results[keyword] = !(decoded.results.isEmpty)
                    } catch {
                        print("Decoding error for \(keyword): \(error)")
                        results[keyword] = false
                    }
                }
                group.leave()
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
}
