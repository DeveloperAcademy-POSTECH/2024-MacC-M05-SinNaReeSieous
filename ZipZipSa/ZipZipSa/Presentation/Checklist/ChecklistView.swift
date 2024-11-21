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
    
    @State var selectedCategory: [CheckListCategory] = [.security, .insectproof, .ventilation]
    @State var selectedSpaceType: SpaceType = .exterior
    
    var body: some View {
        VStack {
            ChecklistTabView(selectedSpaceType: $selectedSpaceType)
            CheckListList
        }
        .padding(16)
        .ignoresSafeArea(.container, edges: [.bottom])
        .background(Color.brown.opacity(0.2))
    }
}

private extension ChecklistView {
    var CheckListList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                ForEach(spaceCheckListItems) { checkListItem in
                    CheckListRowView(
                        selectedCategory: $selectedCategory,
                        answers: $answers,
                        scores: $scores,
                        checkListItem: checkListItem
                    )
                }
            }
        }
        .onChange(of: categoryScores, { oldValue, newValue in
            print(newValue.sorted(by: { $0.0.rawValue > $1.0.rawValue }))
        })
        .scrollIndicators(.never)
        .contentMargins([.top, .bottom], 26, for: .scrollContent)
    }
    
    // MARK: - Computed Values
    
    var filteredCheckListItems: [CheckListItem] {
        CheckListItem.checkListItems.filter {
            let isBasicCheckListItem = $0.checkListType == .basic
            let isSelectedCategoryCheckListItem = $0.checkListType == .advanced
                                                && selectedCategory.contains($0.basicCategory)
            return isBasicCheckListItem || isSelectedCategoryCheckListItem
        }
    }
    
    var spaceCheckListItems: [CheckListItem] {
        filteredCheckListItems.filter {
            $0.space.type == selectedSpaceType
        }
    }
    
    var categoryScores: [CheckListCategory: Float] {
        var categoryScores: [CheckListCategory: Float] = [:]
        
        filteredCheckListItems.forEach { checkListItem in
            if checkListItem.basicCategory.isSelectable {
                categoryScores[checkListItem.basicCategory, default: 0.0] += scores[checkListItem.id] ?? 0
            }
            
            for category in checkListItem.crossTip.keys {
                if selectedCategory.contains(category) {
                    categoryScores[category, default: 0.0] += scores[checkListItem.id] ?? 0
                }
            }
        }
        
        return categoryScores
    }
}

#Preview {
    ChecklistView()
}
