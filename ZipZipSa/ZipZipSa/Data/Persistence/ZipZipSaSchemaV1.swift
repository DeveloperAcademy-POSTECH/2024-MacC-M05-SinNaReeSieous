//
//  ZipZipSaSchemaV1.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// v1.0.2 출시 시점의 스키마 동결 사본.
/// 마이그레이션 이력의 출발점으로만 쓰이며, 앱 코드는 절대 이 타입들을 직접 사용하지 않는다.
/// 이 파일은 수정하지 않는다 — 스키마가 바뀌면 새 버전(V3, V4…)을 추가한다.
enum ZipZipSaSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 2)

    static var models: [any PersistentModel.Type] {
        [User.self, ChecklistCategoryData.self, HomeData.self, RentalFeeData.self,
         LocationData.self, FacilityData.self, MemoData.self, HazardData.self]
    }

    @Model
    final class User {
        @Relationship(deleteRule: .cascade)
        var favoriteCategoryData: [ChecklistCategoryData]

        init(favoriteCategoryData: [ChecklistCategoryData] = []) {
            self.favoriteCategoryData = favoriteCategoryData
        }
    }

    @Model
    final class ChecklistCategoryData {
        var rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    @Model
    final class HomeData {
        @Attribute(.unique)
        var id: UUID = UUID()

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

        var selectedCategoryData: [ChecklistCategoryData] = []
        var answerData: Data? = nil
        var scoreData: Data? = nil
        var resultMaxScoreData: Data? = nil
        var resultScoreData: Data? = nil
        var resultHazardData: [HazardData] = []
        var memoData: [MemoData]

        var facilitiesData: [FacilityData] = []
        var modelImageData: Data? = nil

        init(
            homeName: String = "",
            homeCategory: String? = nil,
            homeRentalTypeData: String? = nil,
            homeAreaPyeong: String = "",
            homeAreaSquareMeter: String = "",
            homeDirectionData: String? = nil,
            rentalFeeData: [RentalFeeData] = [],
            imageData: Data? = nil,
            location: LocationData? = nil,
            locationText: String? = nil,
            memoData: [MemoData] = []
        ) {
            self.homeName = homeName
            self.homeCategoryData = homeCategory
            self.homeRentalTypeData = homeRentalTypeData
            self.homeAreaPyeong = homeAreaPyeong
            self.homeAreaSquareMeter = homeAreaSquareMeter
            self.homeDirectionData = homeDirectionData
            self.rentalFeeData = rentalFeeData
            self.imageData = imageData
            self.location = location
            self.locationText = locationText
            self.memoData = memoData
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
    }

    @Model
    final class FacilityData {
        var rawValue: String

        init(rawValue: String = "") {
            self.rawValue = rawValue
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
}
