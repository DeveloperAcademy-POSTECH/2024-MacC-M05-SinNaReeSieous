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
                ForEach(ChecklistCategory.selectionOrder, id: \.self) { category in
                    if let meta = category.selectionMeta {
                        CategoryButton(for: category, meta: meta)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private extension CategoryView {

    func CategoryButton(for category: ChecklistCategory, meta: ChecklistCategory.SelectionMeta) -> some View {
        let isSelected = selectedCategories.contains(category)

        return Button {
            toggleCategory(category, meta: meta)
        } label: {
            Image(isSelected ? meta.onImage : meta.offImage)
                .resizable()
                .scaledToFit()
                .frame(width: widht, height: widht/166*130)
        }
    }

    func toggleCategory(_ category: ChecklistCategory, meta: ChecklistCategory.SelectionMeta) {
        // 카테고리 선택 해제
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
            totalTime -= meta.requiredTime
            currentMessage = ""

        } else {  // 새로운 카테고리 선택
            selectedCategories.insert(category)
            totalTime += meta.requiredTime
            currentMessage = meta.message
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
