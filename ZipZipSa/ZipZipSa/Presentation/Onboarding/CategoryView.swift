//
//  CategoryView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/25/24.
//

import SwiftUI

struct CategoryView: View {
    private let categories: [Category] = [
        Category(onImage: "InsectProofColor", offImage: "InsectProofSepia"),
        Category(onImage: "CleanlinessColor", offImage: "CleanlinessSepia"),
        Category(onImage: "SecurityColor", offImage: "SecuritySepia"),
        Category(onImage: "VentilationColor", offImage: "VentilationSepia"),
        Category(onImage: "SoundproofColor", offImage: "SoundproofSepia"),
        Category(onImage: "LightedColor", offImage: "LightedSepia")
    ]
    
    @State private var selectedCategories: Set<String> = []
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 0) {
            ForEach(categories, id: \.offImage) { category in
                categoryButton(for: category)
            }
        }
    }
    
    private func categoryButton(for category: Category) -> some View {
        let isSelected = selectedCategories.contains(category.onImage)
        
        return Button(action: {
            if isSelected {
                selectedCategories.remove(category.onImage)
            } else {
                selectedCategories.insert(category.onImage)
            }
        }) {
            VStack {
                Image(isSelected ? category.onImage : category.offImage)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.top, 12)
        }
        .foregroundColor(.black)
    }
}

struct Category {
    let onImage: String
    let offImage: String
}
#Preview {
    CategoryView()
}
