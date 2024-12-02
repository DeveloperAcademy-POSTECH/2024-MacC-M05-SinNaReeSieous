//
//  CategoryView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/25/24.
//

import SwiftUI
struct CategoryView: View {
    @Binding var totalTime: Int
    @Binding var currentMessage: String
    @Binding var selectedCategories: Set<ChecklistCategory>
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 11),
                GridItem(.flexible(), spacing: 11)
            ], spacing: 12) {
                ForEach(OnboardingCategory.categories, id: \.checklistCategory) { category in
                    CategoryButton(for: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private extension CategoryView {
    
    func CategoryButton(for category: OnboardingCategory) -> some View {
        let isSelected = selectedCategories.contains(category.checklistCategory)
        
        return Button {
            toggleCategory(category)
        } label: {
            Image(isSelected ? category.onImage : category.offImage)
                .resizable()
                .scaledToFit()
                .frame(width: widht, height: widht/166*130)
        }
    }
    
    func toggleCategory(_ category: OnboardingCategory) {
        // 카테고리 선택 해제
        if selectedCategories.contains(category.checklistCategory) {
            selectedCategories.remove(category.checklistCategory)
            totalTime -= category.requiredTime
            currentMessage = ""
            
        } else {  // 새로운 카테고리 선택
            selectedCategories.insert(category.checklistCategory)
            totalTime += category.requiredTime
            currentMessage = category.categoryMessage
        }
    }
    
    var widht: CGFloat {
        return UIScreen.isSe ? (UIScreen.screenSize.width-80)/2 : (UIScreen.screenSize.width-43)/2
    }
}

#Preview {
    CategoryView(totalTime: .constant(10),
                 currentMessage: .constant(""),
                 selectedCategories: .constant([]))
}
