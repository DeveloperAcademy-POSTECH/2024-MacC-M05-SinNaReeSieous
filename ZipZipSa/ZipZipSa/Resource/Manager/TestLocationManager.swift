//
//  TestLocationManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import CoreLocation

class TestLocationManager: NSObject, ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager = CLLocationManager()
    private var locationUpdateHandler: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    private var authorizationChangeHandler: ((CLAuthorizationStatus) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAuthorization() async throws {
        try await withCheckedThrowingContinuation { continuation in
            if CLLocationManager.locationServicesEnabled() {
                locationManager.requestWhenInUseAuthorization()
                authorizationChangeHandler = { status in
                    switch status {
                    case .authorizedWhenInUse, .authorizedAlways:
                        continuation.resume()
                    case .denied, .restricted:
                        continuation.resume(throwing: NSError(domain: "LocationAccessDenied", code: 1, userInfo: nil))
                    default:
                        continuation.resume(throwing: NSError(domain: "UnknownAuthorizationStatus", code: 1, userInfo: nil))
                    }
                }
            } else {
                continuation.resume(throwing: NSError(domain: "LocationServicesDisabled", code: 1, userInfo: nil))
            }
        }
    }
    
    func fetchCurrentLocation() async throws -> CLLocationCoordinate2D {
        guard CLLocationManager.locationServicesEnabled() else {
            throw NSError(domain: "LocationServicesDisabled", code: 1, userInfo: nil)
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .notDetermined:
            try await requestLocationAuthorization()
        case .denied, .restricted:
            throw NSError(domain: "LocationAccessDenied", code: 1, userInfo: nil)
        @unknown default:
            throw NSError(domain: "UnknownAuthorizationStatus", code: 1, userInfo: nil)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationUpdateHandler = { result in
                continuation.resume(with: result)
            }
            locationManager.startUpdatingLocation()
        }
    }
}

extension TestLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
            locationUpdateHandler?(.success(location.coordinate))
            locationUpdateHandler = nil
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationChangeHandler?(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationUpdateHandler?(.failure(error))
        locationUpdateHandler = nil
    }
}
