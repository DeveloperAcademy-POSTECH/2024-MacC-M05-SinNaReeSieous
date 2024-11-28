//
//  LocationManager.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/21/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                print("위치 서비스가 비활성화되어 있습니다.")
            }
        }
    }

    func fetchLocation() {
        guard let status = locationStatus else {
            print("위치 권한 상태가 확인되지 않았습니다.")
            return
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            print("위치 서비스 권한 요청 중")
            requestLocationAuthorization()
        case .restricted, .denied:
            print("위치 서비스 권한이 거부되었습니다.")
        @unknown default:
            print("알 수 없는 상태입니다.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("위치 권한이 승인되었습니다.")
            fetchLocation()
        } else if status == .denied {
            print("위치 권한이 거부되었습니다.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location.coordinate
            print("현재위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch user location: \(error.localizedDescription)")
    }
}
