//
//  HomeData.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/29/24.
//

import Foundation
import MapKit
import SwiftData

@Model
final class HomeData {
    var homeName: String
    var address: String
    var homeCategoryData: String?
    var homeRentalTypeData: String?
    var homeAreaPyeong: String
    var homeAreaSquareMeter: String
    var homeDirectionData: String?
    
    @Relationship(deleteRule: .cascade)
    var rentalFee: [RentalFeeData]
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var location: LocationData?
    var locationText: String?
    
    init(
        homeName: String = "",
        address: String = "",
        homeCategory: String? = nil,
        homeRentalTypeData: String? = nil,
        homeAreaPyeong: String = "",
        homeAreaSquareMeter: String = "",
        homeDirectionData: String? = nil,
        rentalFee: [RentalFeeData] = [RentalFeeData(), RentalFeeData(), RentalFeeData(), RentalFeeData()],
        imageData: Data? = nil,
        location: LocationData? = nil,
        locationText: String? = nil
    ) {
        self.homeName = homeName
        self.address = address
        self.homeCategoryData = homeCategory
        self.homeRentalTypeData = homeRentalTypeData
        self.homeAreaPyeong = homeAreaPyeong
        self.homeAreaSquareMeter = homeAreaSquareMeter
        self.homeDirectionData = homeDirectionData
        self.rentalFee = rentalFee
        self.imageData = imageData
        self.location = location
        self.locationText = locationText
    }
}

extension HomeData {
    var homeImage: UIImage? {
        if let data = imageData,
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    var homeCategoryType: HomeCategory? {
        if let homeCategoryData {
            return HomeCategory(rawValue: homeCategoryData)
        } else {
            return nil
        }
    }
    
    var homeRentalType: HomeRentalType? {
        if let homeRentalTypeData {
            return HomeRentalType(rawValue: homeRentalTypeData)
        } else {
            return nil
        }
    }
    
    var homeDirectionType: HomeDirection? {
        if let homeDirectionData {
            return HomeDirection(rawValue: homeDirectionData)
        } else {
            return nil
        }
    }
}

@Model
final class RentalFeeData {
    var value: String
    
    init(value: String = "") {
        self.value = value
    }
}

@Model
final class LocationData {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D?) {
        self.latitude = coordinate?.latitude ?? 0.0
        self.longitude = coordinate?.longitude ?? 0.0
    }
}

extension LocationData {
    // CLLocationCoordinate2D를 반환하는 계산 속성
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
