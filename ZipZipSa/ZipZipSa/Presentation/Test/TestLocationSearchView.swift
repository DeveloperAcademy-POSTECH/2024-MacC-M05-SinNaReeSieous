//
//  TestLocationSearchView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import SwiftUI
import MapKit

struct TestLocationSearchView: View {
    @StateObject private var locationManager = TestLocationManager()
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            TextField("주소를 입력하세요", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("검색") {
                searchAddress(searchText)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            List(searchResults, id: \.self) { item in
                Button(action: {
                    if let coordinate = item.placemark.location?.coordinate {
                        selectedCoordinate = coordinate
                        searchText = item.name ?? "선택된 주소"
                        print("선택된 좌표: \(coordinate.latitude), \(coordinate.longitude)")
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "알 수 없는 장소")
                            .font(.headline)
                        if let addressLine = formatAddress(from: item.placemark) {
                            Text(addressLine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Button("현재위치 가져오기") {
                locationManager.requestLocationAuthorization()
                fetchCurrentLocation()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            if let selectedCoordinate = selectedCoordinate {
                Text("선택된 좌표: \(selectedCoordinate.latitude), \(selectedCoordinate.longitude)")
                    .padding()
            }
        }
    }
    
    private func searchAddress(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.searchResults = response.mapItems.uniqued()
            } else if let error = error {
                print("주소 검색 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchCurrentLocation() {
        locationManager.fetchCurrentLocation { result in
            switch result {
            case .success(let coordinate):
                selectedCoordinate = coordinate
                reverseGeocode(coordinate)
                print("현재위치 좌표: \(coordinate.latitude), \(coordinate.longitude)")
            case .failure(let error):
                print("현재위치 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                searchText = formatAddress(from: placemark) ?? "현재 위치를 가져올 수 없습니다."
            } else if let error = error {
                print("역지오코딩 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func formatAddress(from placemark: CLPlacemark) -> String? {
        let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
        let locality = placemark.locality ?? "" // 시/군/구
        let thoroughfare = placemark.thoroughfare ?? "" // 도로명
        let subThoroughfare = placemark.subThoroughfare ?? "" // 도로번호
        let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            .trimmingCharacters(in: .whitespaces)
        return address.isEmpty ? nil : address
    }
    
    private func formatAddress(from placemark: MKPlacemark) -> String? {
        let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
        let locality = placemark.locality ?? "" // 시/군/구
        let thoroughfare = placemark.thoroughfare ?? "" // 도로명
        let subThoroughfare = placemark.subThoroughfare ?? "" // 도로번호
        let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            .trimmingCharacters(in: .whitespaces)
        return address.isEmpty ? nil : address
    }
}

extension Array where Element == MKMapItem {
    func uniqued() -> [MKMapItem] {
        var seen = Set<String>()
        return self.filter { item in
            let identifier = "\(item.name ?? "")_\(item.placemark.coordinate.latitude)_\(item.placemark.coordinate.longitude)"
            if seen.contains(identifier) {
                return false
            } else {
                seen.insert(identifier)
                return true
            }
        }
    }
}


#Preview {
    TestLocationSearchView()
}
