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
    
    // MARK: - Essential
    
    var homeName: String
    var homeCategoryData: String?
    var homeRentalTypeData: String?
    var homeAreaPyeong: String
    var homeAreaSquareMeter: String
    var homeDirectionData: String?
    
    @Relationship(deleteRule: .cascade)
    var rentalFeeData: [RentalFeeData]
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var location: LocationData?
    var locationText: String?
    
    // MARK: - Checklist
    
    var selectedCategoryData: [ChecklistCategoryData] = []
    var answerData: Data? = nil
    var scoreData: Data? = nil
    var resultMaxScoreData: Data? = nil
    var resultScoreData: Data? = nil
    var resultHazardData: [HazardData] = []
    var memoData: [MemoData] = [MemoData(), MemoData(), MemoData(), MemoData(), MemoData()]
    
    // MARK: - ResultCard
    
    var facilitiesData: [FacilityData] = []
    var modelImageData: Data? = nil
    
    init(
        homeName: String = "",
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
        self.homeCategoryData = homeCategory
        self.homeRentalTypeData = homeRentalTypeData
        self.homeAreaPyeong = homeAreaPyeong
        self.homeAreaSquareMeter = homeAreaSquareMeter
        self.homeDirectionData = homeDirectionData
        self.rentalFeeData = rentalFee
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
    
    // Dictionary를 저장하기 위한 메서드
    func saveDictionary<T: Encodable>(dictionary: T) -> Data? {
        do {
            // Dictionary를 JSON 데이터로 변환
            let jsonData = try JSONEncoder().encode(dictionary)
            return jsonData
        } catch {
            print("Error serializing dictionary: \(error)")
            return nil
        }
    }
    
    // 저장된 데이터를 복원하는 메서드
    func loadDictionary<T: Decodable>(data: Data?, type: T.Type) -> T? {
        guard let data else { return nil }
        do {
            // JSON 데이터를 Dictionary로 변환
            let dictionary = try JSONDecoder().decode(T.self, from: data)
            return dictionary
        } catch {
            print("Error deserializing dictionary: \(error)")
            return nil
        }
    }
    
    var selectedCategories: [ChecklistCategory] {
        var categories: [ChecklistCategory] = []
        
        for favoriteCategory in selectedCategoryData {
            if let category = ChecklistCategory(rawValue: favoriteCategory.rawValue) {
                categories.append(category)
            }
        }
        
        return categories
    }
    
    var modelImage: UIImage? {
        if let data = modelImageData,
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    var facilities: [Facility] {
        var facilites: [Facility] = []
        
        for facilityData in facilitiesData {
            if let facility = Facility(rawValue: facilityData.rawValue) {
                facilites.append(facility)
            }
        }
        
        return facilites
    }
    
    var hazards: [Hazard] {
        var hazards: [Hazard] = []
        
        for hazard in resultHazardData {
            if let hazard = Hazard(rawValue: hazard.rawValue) {
                hazards.append(hazard)
            }
        }
        
        return hazards
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

@Model
final class FacilityData {
    var rawValue: String
    
    init(rawValue: String = "") {
        self.rawValue = rawValue
    }
    
    var facility: Facility? {
        if let facility = Facility(rawValue: rawValue) {
            return facility
        }
        return nil
    }
}

@Model
final class MemoData {
    var value: String
    
    init(value: String = "") {
        self.value = value
    }
}

@Model
final class HazardData {
    var rawValue: String
    
    init(rawValue: String = "") {
        self.rawValue = rawValue
    }
}

