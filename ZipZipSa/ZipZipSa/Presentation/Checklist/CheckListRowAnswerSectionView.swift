//
//  CheckListRowAnswerSectionView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct CheckListRowAnswerSectionView: View {
    @Binding var answers: [UUID: Set<Int>]
    @Binding var scores: [UUID: Float]
    let checkListItem: CheckListItem
    
    private let horizontalSpacing: CGFloat = 8
    private let verticalSpacing: CGFloat = 8
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(answerOptions.indices, id: \.self) { index in
                AnswerButton(index: index)
            }
        }
        .onChange(of: scores) { oldValue, newValue in
            print(newValue)
        }
    }
}

private extension CheckListRowAnswerSectionView {
    
    // MARK: - View
    
    func AnswerButton(index: Int) -> some View {
        Button {
            applyAnswerResult(index: index, isSelected: answers[checkListItem.id]?.contains(index) ?? false)
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(answers[checkListItem.id]?.contains(index) ?? false ? .blue : .white)
                .frame(height: 43)
                .overlay {
                    Text(checkListItem.question.answerOptions[index])
                        .foregroundStyle(.black)
                }
        }
    }
    
    // MARK: - Computede Values
    
    var answerType: AnswerType {
        checkListItem.question.answerType
    }
    
    var answerOptions: [String] {
        checkListItem.question.answerOptions
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10),
              count: (answerType == .twoChoices) ? 2 : 3)
    }
    
    // MARK: - Action
    
    func applyAnswerResult(index: Int, isSelected: Bool) {
        switch answerType {
        case .multiSelect(let basicScore):
            if isSelected {
                answers[checkListItem.id, default: Set<Int>([index])].remove(index)
                scores[checkListItem.id] = Float(answers[checkListItem.id]?.count ?? 0) * -0.5 + basicScore
            } else {
                answers[checkListItem.id, default: Set<Int>([index])].insert(index)
                scores[checkListItem.id] = Float(answers[checkListItem.id]?.count ?? 0) * -0.5 + basicScore
            }
        case .multiChoices:
            if isSelected {
                answers[checkListItem.id] = nil
                scores[checkListItem.id] = Float(0)
            } else {
                answers[checkListItem.id] = Set([index])
                scores[checkListItem.id] = Float(index-1)
            }
        case .twoChoices:
            if isSelected {
                answers[checkListItem.id] = nil
                scores[checkListItem.id] =  Float(0)
            } else {
                answers[checkListItem.id] = Set([index])
                scores[checkListItem.id] = Float(index == 1 ? 1 : -1)
            }
        }
    }
}

#Preview {
    CheckListRowView(selectedCategory: .constant([]), answers: .constant([:]), scores: .constant([:]), checkListItem: CheckListItem.CheckListItems[0])
}
