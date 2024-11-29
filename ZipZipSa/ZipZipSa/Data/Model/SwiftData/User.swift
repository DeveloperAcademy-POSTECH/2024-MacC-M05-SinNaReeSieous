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
    var favoriteCategories: [String]
    
    init(favoriteCategories: [String]) {
        self.favoriteCategories = favoriteCategories
    }
    
    var categories: [ChecklistCategory] {
        var categories: [ChecklistCategory] = []
        
        for favoriteCategory in favoriteCategories {
            if let category = ChecklistCategory(rawValue: favoriteCategory) {
                categories.append(category)
            }
        }
        
        return categories
    }
}
