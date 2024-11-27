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
    @State private var selectedCategories: Set<String> = []
    @State private var selectionOrder: [String] = [] // 선택 순서를 추적하기 위한 배열
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 11),
                GridItem(.flexible(), spacing: 11)
            ], spacing: 11) {
                ForEach(Category.categories, id: \.offImage) { category in
                    CategoryButton(for: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private extension CategoryView {
    
    func CategoryButton(for category: Category) -> some View {
        let isSelected = selectedCategories.contains(category.onImage)
        
        return Button(action: {
            toggleCategory(category)
        }) {
            VStack {
                Image(isSelected ? category.onImage : category.offImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    func toggleCategory(_ category: Category) {
            if selectedCategories.contains(category.onImage) {
                // 카테고리 선택 해제
                selectedCategories.remove(category.onImage)
                totalTime -= category.requiredTime
                selectionOrder.removeAll(where: { $0 == category.offImage })
                
                if selectedCategories.isEmpty {
                    // 선택된 카테고리가 없을 때 메시지 초기화
                    currentMessage = ""
                } else {
                    // 마지막으로 선택된 카테고리의 메시지를 표시
                    if let lastSelectedOffImage = selectionOrder.last,
                       let lastCategory = Category.categories.first(where: { $0.offImage == lastSelectedOffImage }) {
                        currentMessage = lastCategory.categoryMessage
                    }
                }
            } else {
                // 새로운 카테고리 선택
                selectedCategories.insert(category.onImage)
                totalTime += category.requiredTime
                selectionOrder.append(category.offImage)
                currentMessage = category.categoryMessage
            }
        }
    }

#Preview {
    CategoryView(totalTime: .constant(10),
                 currentMessage: .constant(""))
}
