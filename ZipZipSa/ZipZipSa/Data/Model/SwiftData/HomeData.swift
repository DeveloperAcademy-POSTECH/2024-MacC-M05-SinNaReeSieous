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
    var homeCategory: String
    var homeRentalType: String
    var homeAreaPyeong: String
    var homeAreaSquareMeter: String
    var selectedHomeDirection: String
    
    @Relationship(deleteRule: .cascade)
    var rentalFee: [RentalFeeData]
    
    @Attribute(.externalStorage)
    var selectedImageData: Data?
    
    var location: LocationData?
    
    init(
        homeName: String = "",
        address: String = "",
        homeCategory: String = "",
        homeRentalType: String = "",
        homeAreaPyeong: String = "",
        homeAreaSquareMeter: String = "",
        selectedHomeDirection: String = "",
        rentalFee: [RentalFeeData] = [RentalFeeData(), RentalFeeData(), RentalFeeData(), RentalFeeData()],
        selectedImageData: Data? = nil,
        location: LocationData? = nil
    ) {
        self.homeName = homeName
        self.address = address
        self.homeCategory = homeCategory
        self.homeRentalType = homeRentalType
        self.homeAreaPyeong = homeAreaPyeong
        self.homeAreaSquareMeter = homeAreaSquareMeter
        self.selectedHomeDirection = selectedHomeDirection
        self.rentalFee = rentalFee
        self.selectedImageData = selectedImageData
        self.location = location
    }
}

extension HomeData {
    
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
}

extension LocationData {
    // CLLocationCoordinate2D를 반환하는 계산 속성
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
