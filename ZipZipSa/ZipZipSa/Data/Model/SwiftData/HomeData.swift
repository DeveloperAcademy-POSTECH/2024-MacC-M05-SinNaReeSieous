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
    
    @Attribute(.unique)
    var id: UUID = UUID()
    
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

    /// 레거시(V1) 답변 blob. [Int: Set<Int>] JSON.
    /// V2부터 checklistAnswers가 원본이고, 이 blob은 롤백 대비 백업 미러로만 유지한다.
    /// 다음 메이저 버전에서 제거 예정.
    var answerData: Data? = nil

    /// 레거시(V1) 점수 blob. [Int: Float] JSON. answerData에서 파생 가능한 값이라
    /// V2에서는 저장하지 않아도 되지만 롤백 대비로 함께 미러링한다.
    var scoreData: Data? = nil

    var resultMaxScoreData: Data? = nil
    var resultScoreData: Data? = nil
    var resultHazardData: [HazardData] = []
    var memoData: [MemoData]

    // MARK: - Checklist (V2)

    /// 질문별 답변 레코드 (V2 원본). 질문의 영구 code로 식별한다.
    @Relationship(deleteRule: .cascade)
    var checklistAnswers: [ChecklistAnswerData] = []

    /// 이 집을 기록할 당시 노출됐던 질문 code 목록.
    /// 커스텀 체크리스트 도입 후에도 과거 기록을 당시 질문 세트로 재현하기 위한 스냅샷.
    var usedQuestionCodes: [String] = []
    
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
        rentalFee: [RentalFeeData] = [RentalFeeData(index: 0), RentalFeeData(index: 1), RentalFeeData(index: 2), RentalFeeData(index: 3)],
        imageData: Data? = nil,
        location: LocationData? = nil,
        locationText: String? = nil,
        memoData: [MemoData] = [MemoData(index: 0), MemoData(index: 1), MemoData(index: 2), MemoData(index: 3), MemoData(index: 4)]
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
        self.memoData = memoData
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
            ZZSLog.error("Error serializing dictionary: \(error)")
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
            ZZSLog.error("Error deserializing dictionary: \(error)")
            return nil
        }
    }
    
    /// 답변 레코드를 [질문 code: 선택 인덱스 집합] 형태로 변환한다.
    var checklistAnswersByCode: [String: Set<Int>] {
        var result: [String: Set<Int>] = [:]
        for answer in checklistAnswers {
            result[answer.questionCode] = answer.selection
        }
        return result
    }

    /// 답변 딕셔너리를 레코드로 저장한다 (기존 레코드는 교체).
    func setChecklistAnswers(_ answers: [String: Set<Int>]) {
        checklistAnswers = answers.map {
            ChecklistAnswerData(questionCode: $0.key, selectedIndices: $0.value.sorted())
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
    var index: Int
    var value: String
    
    init(index: Int, value: String = "") {
        self.index = index
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
    var index: Int
    var value: String
    
    init(index: Int, value: String = "") {
        self.index = index
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

