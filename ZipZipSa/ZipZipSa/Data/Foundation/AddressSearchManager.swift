//
//  AddressSearchManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import Foundation
import CoreLocation

class AddressSearchManager {
    static let shared = AddressSearchManager()
    
    private let apiKey: String
    
    private init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    }
    
    func fetchAutocompleteResults(for query: String) async throws -> [(description: String, placeID: String)] {
        guard !query.isEmpty else { return [] }
        
        let urlString = ZipLiteral.APIEndpoints.autoComplete(query: query, apiKey: apiKey).url
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.AddressSearchError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AutocompleteResponse.self, from: data)
            return response.predictions.map { ($0.description, $0.place_id) }
        } catch {
            throw NetworkError.AddressSearchError.networkError(description: error.localizedDescription)
        }
    }
    
    func fetchCoordinates(for placeID: String) async throws -> CLLocationCoordinate2D {
        let urlString = ZipLiteral.APIEndpoints.placeDetails(placeID: placeID, apiKey: apiKey).url
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.AddressSearchError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PlaceDetailsResponse.self, from: data)
            let location = response.result.geometry.location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } catch {
            throw NetworkError.AddressSearchError.networkError(description: error.localizedDescription)
        }
    }
    
    func getAddressForLatLng(latitude: Double, longitude: Double) async throws -> String {
        let urlString = ZipLiteral.APIEndpoints.reverseGeocode(latitude: latitude, longitude: longitude, apiKey: apiKey).url
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.AddressSearchError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let firstResult = results.first,
               let address = firstResult["formatted_address"] as? String {
                return address
            } else {
                throw NetworkError.AddressSearchError.noResults
            }
        } catch {
            throw NetworkError.AddressSearchError.networkError(description: error.localizedDescription)
        }
    }
}
