//
//  ChecklistView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ChecklistView: View {
    @State var answers: [UUID: Set<Int>] = [:]
    @State var scores: [UUID: Float] = [:]
    @State var selectedCategory: [ChecklistCategory] = [.security, .insectproof, .ventilation]
    @State var selectedSpaceType: SpaceType = .exterior
    
    var body: some View {
        VStack {
            ScrollView {
                NavigationBarTitle
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ChecklistList
                            .padding(.top, 18)
                    } header: {
                        ChecklistTabView(selectedSpaceType: $selectedSpaceType)
                            .background(Color.brown)
                    }
                }
            }
            .clipped()
            .scrollIndicators(.never)
            .contentMargins(.bottom, 26, for: .scrollContent)
            
            ZZSMainButton(
                action: { print("Tapped") },
                text: "집 구조 스캔하기"
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .background(Color.brown)
        }
        //.ignoresSafeArea(.container, edges: [.bottom])
        .background(Color.brown)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

private extension ChecklistView {
    
    // MARK: - View
    
    var ChecklistList: some View {
        VStack(alignment: .leading, spacing: 40) {
            ForEach(spaceChecklistItems) { checkListItem in
                ChecklistRowView(
                    selectedCategory: $selectedCategory,
                    answers: $answers,
                    scores: $scores,
                    checkListItem: checkListItem
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    var NavigationBarTitle: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("주인님을 위한")
                Text("맞춤 체크리스트예요")
            }
            .font(.title)
            .bold()
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Computed Values
    
    var filteredChecklistItems: [ChecklistItem] {
        ChecklistItem.checklistItems.filter {
            let isBasicCheckListItem = $0.checkListType == .basic
            let isSelectedCategoryCheckListItem = $0.checkListType == .advanced
            && selectedCategory.contains($0.basicCategory)
            return isBasicCheckListItem || isSelectedCategoryCheckListItem
        }
    }
    
    var spaceChecklistItems: [ChecklistItem] {
        filteredChecklistItems.filter {
            $0.space.type == selectedSpaceType
        }
        .sorted { $0.space.questionNumber < $1.space.questionNumber }
    }
    
    func calculateCategoryScores() -> [ChecklistCategory: Float] {
        var categoryScores: [ChecklistCategory: Float] = [:]
        
        filteredChecklistItems.forEach { checklistItem in
            let categories = [checklistItem.basicCategory] + checklistItem.crossTip.keys
            
            for category in categories {
                let isSelectableBasicCategory = checklistItem.basicCategory == category && category.isSelectable
                if selectedCategory.contains(category) || isSelectableBasicCategory {
                    var basicValue: Float = 0.0
                    switch checklistItem.question.answerType {
                    case .multiSelect(let basicScore, _):
                        basicValue = basicScore
                    default:
                        basicValue = 1.0
                    }
                    categoryScores[category, default: 0.0] += scores[checklistItem.id] ?? basicValue
                }
            }
        }
        
        return categoryScores
    }
    
    func calculateMaxCategoryScores() -> [ChecklistCategory: Float] {
        var categoryScores: [ChecklistCategory: Float] = [:]
        
        filteredChecklistItems.forEach { checklistItem in
            let categories = [checklistItem.basicCategory] + checklistItem.crossTip.keys
            
            for category in categories {
                let isSelectableBasicCategory = checklistItem.basicCategory == category && category.isSelectable
                if selectedCategory.contains(category) || isSelectableBasicCategory {
                    switch checklistItem.question.answerType {
                    case .multiSelect(let basicScore, let answerDisposition):
                        if answerDisposition == .negative {
                            categoryScores[category, default: 0.0] += basicScore
                        } else if answerDisposition == .positive {
                            let maxScore: Float = Float(checklistItem.question.answerOptions.count) * 0.5
                            categoryScores[category, default: 0.0] += maxScore
                        }
                    default:
                        categoryScores[category, default: 0.0] += 2.0
                    }
                }
            }
        }
        
        return categoryScores
    }
    
    func getHazardResult() -> [Hazard] {
        var hazards: [Hazard] = []
        
        filteredChecklistItems.forEach { checklistItem in
            guard let hazard = checklistItem.hazard else {
                return
            }
            let hasHazard = answers[checklistItem.id] == [0]
            if hasHazard {
                hazards.append(hazard)
            }
        }
        
        hazards.sort { $0.text < $1.text }
        
        return hazards
    }
}

#Preview {
    NavigationView {
        ChecklistView()
    }
}
