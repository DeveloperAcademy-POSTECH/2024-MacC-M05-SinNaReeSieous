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
    
    var filteredCheckListItems: [CheckListItem] {
        CheckListItem.CheckListItems.filter {
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
    
    var body: some View {
        VStack {
            ChecklistTabView(selectedSpaceType: $selectedSpaceType)
            CheckListList
        }
    }
}

private extension ChecklistView {
    var CheckListList: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
    }
}

#Preview {
    ChecklistView()
}
