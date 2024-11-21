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
            ChecklistTabView(selectedSpaceType: $selectedSpaceType)
            ChecklistList
        }
        .padding(16)
        .ignoresSafeArea(.container, edges: [.bottom])
        .background(Color.brown.opacity(0.2))
    }
}

private extension ChecklistView {
    var ChecklistList: some View {
        ScrollView {
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
        }
//        .onChange(of: scores, { oldValue, newValue in
//            print(calculateCategoryScores().sorted(by: { $0.key.rawValue > $1.key.rawValue }))
//            print("================== DIVIDER ==================")
//            print(calculateMaxCategoryScores().sorted(by: { $0.key.rawValue > $1.key.rawValue }))
//        })
        .scrollIndicators(.never)
        .contentMargins([.top, .bottom], 26, for: .scrollContent)
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
}

#Preview {
    ChecklistView()
}
