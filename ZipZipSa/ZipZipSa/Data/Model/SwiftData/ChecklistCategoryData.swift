//
//  ChecklistCategoryData.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/29/24.
//

import Foundation
import SwiftData

@Model
final class ChecklistCategoryData {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension ChecklistCategoryData {
    var category: ChecklistCategory? {
        return ChecklistCategory(rawValue: name)
    }
}