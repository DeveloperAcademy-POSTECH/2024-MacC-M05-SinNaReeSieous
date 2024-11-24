//
//  ChecklistRowAnswerSectionView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowAnswerSectionView: View {
    @Binding var answers: [UUID: Set<Int>]
    @Binding var scores: [UUID: Float]
    let checkListItem: ChecklistItem
    
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 8
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(answerOptions.indices, id: \.self) { index in
                AnswerButton(index: index)
            }
        }
    }
}

private extension ChecklistRowAnswerSectionView {
    
    // MARK: - View
    
    func AnswerButton(index: Int) -> some View {
        let color = accentColor(index: index)
        let isSelected = answers[checkListItem.id]?.contains(index) ?? false
        return Button {
            applyScore(index: index, isSelected: isSelected)
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? color.opacity(0.2) : .white)
                .frame(height: 43)
                .overlay {
                    Text(checkListItem.question.answerOptions[index])
                        .foregroundStyle(.black)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? color : .white,
                                lineWidth: isSelected ? 1 : 0)
                        .padding(1)
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
        Array(repeating: GridItem(.flexible(), spacing: horizontalSpacing),
              count: (answerType == .twoChoices) ? 2 : 3)
    }
    
    func accentColor(index: Int) -> Color {
        switch answerType {
        case .twoChoices:
            return index == 1 ? Color.blue : Color.red
        case .multiChoices:
            switch index {
            case 0: return Color.red
            case 1: return Color.green
            case 2: return Color.blue
            default: return Color.green
            }
        case .multiSelect(_, let answerDisposition):
            switch answerDisposition {
            case .negative: return Color.red
            case .neutral: return Color.green
            case .positive: return Color.blue
            }
        }
    }
    
    // MARK: - Action
    
    func applyScore(index: Int, isSelected: Bool) {
        switch answerType {
        case .multiSelect(let basicScore, let answerDisposition):
            let value: Float = answerDisposition == .negative ? -0.5 : 0.5
            if isSelected {
                answers[checkListItem.id, default: Set<Int>([index])].remove(index)
                scores[checkListItem.id] = Float(answers[checkListItem.id]?.count ?? 0) * value + basicScore
            } else {
                answers[checkListItem.id, default: Set<Int>([index])].insert(index)
                scores[checkListItem.id] = Float(answers[checkListItem.id]?.count ?? 0) * value + basicScore
            }
        case .multiChoices:
            if isSelected {
                answers[checkListItem.id] = nil
                scores[checkListItem.id] = Float(1)
            } else {
                answers[checkListItem.id] = Set([index])
                scores[checkListItem.id] = Float(index)
            }
        case .twoChoices:
            if isSelected {
                answers[checkListItem.id] = nil
                scores[checkListItem.id] =  Float(1)
            } else {
                answers[checkListItem.id] = Set([index])
                scores[checkListItem.id] = Float(index == 1 ? 2 : 0)
            }
        }
    }
}

#Preview {
    ChecklistRowAnswerSectionView(answers: .constant([:]), scores: .constant([:]), checkListItem: ChecklistItem.checklistItems[0])
}
