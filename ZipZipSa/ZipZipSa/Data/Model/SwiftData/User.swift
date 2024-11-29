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
    var favoriteCategories: [ChecklistCategoryData]
    
    init(favoriteCategories: [ChecklistCategoryData] = []) {
        self.favoriteCategories = favoriteCategories
    }
}

extension User {
    var categories: [ChecklistCategory] {
        var categories: [ChecklistCategory] = []
        
        for favoriteCategory in favoriteCategories {
            if let category = ChecklistCategory(rawValue: favoriteCategory.rawValue) {
                categories.append(category)
            }
        }
        
        return categories
    }
}
