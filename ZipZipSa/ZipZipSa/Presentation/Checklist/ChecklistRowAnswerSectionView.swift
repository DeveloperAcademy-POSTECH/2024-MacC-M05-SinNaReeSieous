//
//  ChecklistRowAnswerSectionView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowAnswerSectionView: View {
    @Binding var answers: [ChecklistItem: Set<Int>]
    @Binding var scores: [ChecklistItem: Float]
    @Binding var checklistItem: ChecklistItem
    
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 8
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(answerOptions.indices, id: \.self) { index in
                Button {
                    applyScore(index: index, isSelected: answers[checklistItem]?.contains(index) ?? false)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(answers[checklistItem]?.contains(index) ?? false ? accentColor(index: index) : Color.Button.enable)
                        .frame(height: 43)
                        .overlay {
                            Text(checklistItem.question.answerOptions[index])
                                .foregroundStyle(Color.Text.primary)
                                .applyZZSFont(zzsFontSet: .bodyRegular)
                        }
                }
            }
        }
    }
}

private extension ChecklistRowAnswerSectionView {
    
    // MARK: - View
    
    func AnswerButton(index: Int) -> some View {
        let color = accentColor(index: index)
        return Button {
            applyScore(index: index, isSelected: answers[checklistItem]?.contains(index) ?? false)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(answers[checklistItem]?.contains(index) ?? false ? color : Color.Button.enable)
                .frame(height: 43)
                .overlay {
                    Text(checklistItem.question.answerOptions[index])
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
        }
    }
    
    // MARK: - Computede Values
    
    var answerType: AnswerType {
        checklistItem.question.answerType
    }
    
    var answerOptions: [String] {
        checklistItem.question.answerOptions
    }
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: horizontalSpacing),
              count: (answerType == .twoChoices) ? 2 : 3)
    }
    
    func accentColor(index: Int) -> Color {
        switch answerType {
        case .twoChoices:
            return index == 1 ? Color.Button.positive : Color.Button.negative
        case .multiChoices:
            switch index {
            case 0: return Color.Button.negative
            case 1: return Color.Button.neutral
            case 2: return Color.Button.positive
            default: return Color.green
            }
        case .multiSelect(_, let answerDisposition):
            switch answerDisposition {
            case .negative: return Color.Button.negative
            case .neutral: return Color.Button.neutral
            case .positive: return Color.Button.positive
            }
        }
    }
    
    // MARK: - Action
    
    func applyScore(index: Int, isSelected: Bool) {
        switch answerType {
        case .multiSelect(let basicScore, let answerDisposition):
            let value: Float = answerDisposition == .negative ? -0.5 : 0.5
            if isSelected {
                answers[checklistItem]?.remove(index)
                scores[checklistItem] = Float(answers[checklistItem]?.count ?? 0) * value + basicScore
            } else {
                answers[checklistItem, default: Set()].insert(index)
                scores[checklistItem] = Float(answers[checklistItem]?.count ?? 0) * value + basicScore
            }
        case .multiChoices:
            if isSelected {
                answers[checklistItem] = nil
                scores[checklistItem] = Float(1)
            } else {
                answers[checklistItem] = Set([index])
                scores[checklistItem] = Float(index)
            }
        case .twoChoices:
            if isSelected {
                answers[checklistItem] = nil
                scores[checklistItem] = Float(1)
            } else {
                answers[checklistItem] = Set([index])
                scores[checklistItem] = Float(index == 1 ? 2 : 0)
            }
        }
    }
}

#Preview {
    ChecklistRowAnswerSectionView(answers: .constant([:]), scores: .constant([:]), checklistItem: .constant(ChecklistItem.checklistItems[0]))
}
