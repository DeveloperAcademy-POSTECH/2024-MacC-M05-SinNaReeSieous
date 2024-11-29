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
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ChecklistCategoryData {
    var category: ChecklistCategory? {
        return ChecklistCategory(rawValue: rawValue)
    }
}
