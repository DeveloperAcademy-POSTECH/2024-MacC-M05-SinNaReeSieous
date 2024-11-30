//
//  TestLocationManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import CoreLocation

class TestLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("위치 서비스가 비활성화되어 있습니다.")
        }
    }

    func fetchCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.failure(NSError(domain: "LocationServicesDisabled", code: 1, userInfo: nil)))
            return
        }

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            requestLocationAuthorization()
        case .denied, .restricted:
            completion(.failure(NSError(domain: "LocationAccessDenied", code: 1, userInfo: nil)))
        @unknown default:
            completion(.failure(NSError(domain: "UnknownAuthorizationStatus", code: 1, userInfo: nil)))
        }

        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            print("위치 권한 승인됨")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 가져오기 실패: \(error.localizedDescription)")
    }
}
