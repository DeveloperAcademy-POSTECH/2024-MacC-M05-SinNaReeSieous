//
//  User.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/29/24.
//

import Foundation
import SwiftData

@Model
final class User {
    @Relationship(deleteRule: .cascade)
    var favoriteCategoryData: [ChecklistCategoryData]
    
    init(favoriteCategoryData: [ChecklistCategoryData] = []) {
        self.favoriteCategoryData = favoriteCategoryData
    }
}

extension User {
    var favoriteCategories: [ChecklistCategory] {
        var categories: [ChecklistCategory] = []
        
        for favoriteCategory in favoriteCategoryData {
            if let category = ChecklistCategory(rawValue: favoriteCategory.rawValue) {
                categories.append(category)
            }
        }
        
        return categories
    }
}
