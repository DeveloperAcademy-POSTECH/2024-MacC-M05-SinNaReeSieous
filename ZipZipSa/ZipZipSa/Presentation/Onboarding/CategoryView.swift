//
//  CategoryView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/25/24.
//

import SwiftUI
struct CategoryView: View {
    
    private let categories: [Category] = [
        Category(onImage: "InsectProofColor", offImage: "InsectProofSepia", requiredTime: 3, categoryMessage: "해충 흔적과 방충 시설 상태를 더 꼼꼼히 볼 수 있도록 질문을 추가해둘게요."),
        Category(onImage: "CleanlinessColor", offImage: "CleanlinessSepia", requiredTime: 3, categoryMessage: "집 안에서 놓치기 쉬운 곳까지 구석구석 살펴볼 수 있도록 질문을 추가해둘게요."),
        Category(onImage: "SecurityColor", offImage: "SecuritySepia", requiredTime: 3, categoryMessage: "보안 장치, 주변 환경, 시설까지 꼼꼼히 살필 수 있게 질문을 추가해둘게요."),
        Category(onImage: "VentilationColor", offImage: "VentilationSepia", requiredTime: 3, categoryMessage: "집이 환기하기에 좋은 상태인지 알 수 있도록 체크 포인트를 알려드릴게요!"),
        Category(onImage: "SoundproofColor", offImage: "SoundproofSepia", requiredTime: 3, categoryMessage: "이 집이 소음, 방음 측면에서 어떤지 더 꼼꼼히 알 수 있도록 질문을 추가해둘게요."),
        Category(onImage: "LightedColor", offImage: "LightedSepia", requiredTime: 3, categoryMessage: "집 안에 빛이 잘 들어오는지 좀 더 꼼꼼히 체크할 수 있도록 할게요.")
    ]
    
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
                ForEach(categories, id: \.offImage) { category in
                    CategoryButton(for: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private extension CategoryView {
    
    func CategoryButton(for category: Category) -> some View {
        let isSelected = selectedCategories.contains(category.offImage)
        
        return Button(action: {
            toggleCategory(category)
        }) {
            VStack {
                Image(isSelected ? category.offImage : category.onImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    func toggleCategory(_ category: Category) {
            if selectedCategories.contains(category.offImage) {
                // 카테고리 선택 해제
                selectedCategories.remove(category.offImage)
                totalTime -= category.requiredTime
                selectionOrder.removeAll(where: { $0 == category.offImage })
                
                if selectedCategories.isEmpty {
                    // 선택된 카테고리가 없을 때 메시지 초기화
                    currentMessage = ""
                } else {
                    // 마지막으로 선택된 카테고리의 메시지를 표시
                    if let lastSelectedOffImage = selectionOrder.last,
                       let lastCategory = categories.first(where: { $0.offImage == lastSelectedOffImage }) {
                        currentMessage = lastCategory.categoryMessage
                    }
                }
            } else {
                // 새로운 카테고리 선택
                selectedCategories.insert(category.offImage)
                totalTime += category.requiredTime
                selectionOrder.append(category.offImage)
                currentMessage = category.categoryMessage
            }
        }
    }

struct Category {
    let onImage: String
    let offImage: String
    let requiredTime: Int
    let categoryMessage: String
}
