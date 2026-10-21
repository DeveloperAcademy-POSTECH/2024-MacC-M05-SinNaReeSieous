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

    /// 사용자의 커스텀 체크리스트 템플릿 목록 (스키마 V2).
    @Relationship(deleteRule: .cascade)
    var templates: [ChecklistTemplateData] = []

    /// 현재 사용 중인(대표) 템플릿 id.
    /// 기본 체크리스트도 저장된 템플릿(DefaultTemplateSeeder)이라 보통 nil이 아니다.
    /// nil이거나 삭제된 템플릿을 가리키면 기본 질문 세트(QuestionProvider.defaultQuestions)로 폴백한다.
    var activeTemplateID: UUID? = nil

    init(favoriteCategoryData: [ChecklistCategoryData] = []) {
        self.favoriteCategoryData = favoriteCategoryData
    }
}

extension User {
    /// 현재 대표(활성) 템플릿. activeTemplateID가 nil이거나 삭제된 템플릿을
    /// 가리키면 nil을 반환하고, 호출부는 기본(동적 규칙) 체크리스트로 폴백한다.
    var activeTemplate: ChecklistTemplateData? {
        guard let activeTemplateID else { return nil }
        return templates.first { $0.id == activeTemplateID }
    }

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
