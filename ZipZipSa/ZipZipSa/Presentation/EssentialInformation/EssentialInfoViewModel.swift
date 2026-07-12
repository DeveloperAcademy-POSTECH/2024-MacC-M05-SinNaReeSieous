//
//  EssentialInfoViewModel.swift
//  ZipZipSa
//

import Foundation
import CoreLocation
import Observation

/// 기본정보 화면의 상태와 로직.
/// 기존 EssentialInfoView(첫 기록)와 DetailEssentialInfoView(재열람/수정)에 복붙되어 있던
/// 문구·기본 별명·위치 조회·편의시설 검색 로직을 모드 하나로 흡수했다.
@Observable
@MainActor
final class EssentialInfoViewModel {

    enum Mode {
        /// 집 보러가기 플로우의 첫 기록. 다음 화면 = 체크리스트 첫 기록.
        case homeHunt
        /// 저장된 집의 재열람/수정. 다음 화면 = 체크리스트 재열람.
        case review
    }

    let mode: Mode

    private(set) var isGettingAddress = false

    private let locationManager = LocationManager()

    init(mode: Mode) {
        self.mode = mode
    }

    // MARK: - 화면 문구/분기

    var navigationTitle: String {
        switch mode {
        case .homeHunt: return "기본정보를 알려주세요"
        case .review: return "기본정보예요"
        }
    }

    var bottomButtonText: String {
        switch mode {
        case .homeHunt: return "다음"
        case .review: return "체크리스트 보기"
        }
    }

    var addressPlaceHolder: String {
        if isGettingAddress {
            return "주소를 가져오는중 ..."
        } else {
            return "주소를 입력해 주세요"
        }
    }

    /// 별명이 비었을 때 쓰는 기본 별명. 재열람 모드에서는 저장된 집의 순번을 유지한다.
    func basicHomeName(homes: [HomeData], homeData: HomeData) -> String {
        if mode == .review, let index = homes.firstIndex(of: homeData) {
            return "\(index+1)번째 집"
        }
        return "\(homes.count+1)번째 집"
    }

    // MARK: - 위치/편의시설

    func fetchCurrentLocation(for homeData: HomeData) async {
        do {
            isGettingAddress = true
            let coordinate = try await locationManager.fetchCurrentLocation()
            homeData.location = LocationData(coordinate: coordinate)
            if let address = await reverseGeocode(coordinate) {
                homeData.locationText = address
            } else {
                ZZSLog.error("현재 위치를 가져올 수 없습니다.")
            }
        } catch {
            ZZSLog.error("현재위치 가져오기 실패: \(error.localizedDescription)")
        }
    }

    func searchFacilities(for homeData: HomeData) async {
        if let coordinates = homeData.location?.coordinate {
            do {
                let location = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                let results = try await FacilityManager.searchFacilities(at: location)

                homeData.facilitiesData = Facility.allCases.filter { facility in
                    results[facility.rawValue] == true
                }.map { facility in
                    FacilityData(rawValue: facility.rawValue)
                }
            } catch let networkError as NetworkError {
                networkError.logError()
            } catch {
                ZZSLog.error("Unexpected error: \(error)")
            }
        } else {
            homeData.facilitiesData = []
        }
    }

    /// 화면을 나가기 전 마무리 — 편의시설 검색과 빈 별명 기본값 채우기.
    func completeEditing(homeData: HomeData, homes: [HomeData]) async {
        await searchFacilities(for: homeData)
        if homeData.homeName.isEmpty {
            homeData.homeName = basicHomeName(homes: homes, homeData: homeData)
        }
    }

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let bestPlacemark = placemarks.first else {
                ZZSLog.error("역지오코딩 결과가 없습니다.")
                return nil
            }
            return formatAddress(from: bestPlacemark)
        } catch {
            ZZSLog.error("역지오코딩 실패: \(error.localizedDescription)")
            return nil
        }
    }

    private func formatAddress(from placemark: CLPlacemark) -> String? {
        var components: [String] = []

        if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            components.append(subAdministrativeArea)
        }
        if let locality = placemark.locality {
            components.append(locality)
        }
        if let thoroughfare = placemark.thoroughfare {
            components.append(thoroughfare)
        }
        if let subThoroughfare = placemark.subThoroughfare {
            components.append(subThoroughfare)
        }

        let address = components.joined(separator: " ")
        return address.isEmpty ? nil : address
    }
}
