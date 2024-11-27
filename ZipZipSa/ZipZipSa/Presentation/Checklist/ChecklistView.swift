//
//  ChecklistView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ChecklistView: View {
    @State var answers: [ChecklistItem: Set<Int>] = [:]
    @State var scores: [ChecklistItem: Float] = [:]
    @State var selectedCategory: [ChecklistCategory] = [.security, .insectproof, .ventilation]
    @State var selectedSpaceType: SpaceType = .kitchen
    @State var memoText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    NavigationBarTitle
                    ChecklistList
                }
            }
            .clipped()
            .scrollIndicators(.never)
            .contentMargins(.bottom, 120, for: .scrollContent)
        }
        .overlay(alignment: .bottom) {
            ZZSMainButton(
                action: { print("Tapped") },
                text: "집 구조 스캔하기"
            )
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .onAppear {
            selectedSpaceType = .exterior
        }
        .background(Color.Background.primary)
        .dismissKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

private extension ChecklistView {
    
    // MARK: - View
    
    var ChecklistList: some View {
        ScrollViewReader { scrollView in
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    Spacer().frame(height: 18)
                    ForEach(spaceChecklistItems) { checklistItem in
                        ChecklistRowView(
                            selectedCategory: $selectedCategory,
                            answers: $answers,
                            scores: $scores,
                            checklistItem: checklistItem
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                    Memo
                    
                } header: {
                    ChecklistSpaceButtonStackView(selectedSpaceType: $selectedSpaceType)
                        .id(1)
                }
            }
            .onChange(of: selectedSpaceType) { oldValue, newValue in
                scrollView.scrollTo(1)
            }
        }
    }
    
    var NavigationBarTitle: some View {
        HStack {
            Text("주인님을 위한\n맞춤 체크리스트예요")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    var Memo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("메모")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .headline)
            TextEditor(text: $memoText)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
                .tint(Color.Text.placeholder)
                .overlay(alignment: .topLeading) {
                    if memoText.isEmpty {
                        Text("메모를 입력해 주세요")
                            .foregroundStyle(Color.Text.placeholder)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                            .offset(x: 6, y: 10)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .frame(height: 150)
                .background(Color.Button.enable)
                .clipShape (
                    RoundedRectangle(cornerRadius: 12)
                )
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
        return filteredChecklistItems.filter {
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
                    categoryScores[category, default: 0.0] += scores[checklistItem] ?? basicValue
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
            let hasHazard = answers[checklistItem] == [0]
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
