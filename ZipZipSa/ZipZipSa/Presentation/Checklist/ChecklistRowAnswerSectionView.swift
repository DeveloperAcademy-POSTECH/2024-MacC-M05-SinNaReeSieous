//
//  ChecklistRowAnswerSectionView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowAnswerSectionView: View {
    @Binding var answers: [Int: Set<Int>]
    @Binding var scores: [Int: Float]
    let checklistItem: ChecklistItem
    
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 8
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(answerOptions, id: \.self) { value in
                //let index = checklistItem.question.answerOptions.firstIndex(of: value) ?? 0
                if let index = checklistItem.question.answerOptions.firstIndex(of: value) {
                    AnswerButton(index: index)
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
            applyAnswersAndScores(index: index, isSelected: answers[checklistItem.id]?.contains(index) ?? false)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(answers[checklistItem.id]?.contains(index) ?? false ? color : Color.Button.enable)
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
              count: answerOptions.count > 3 ? 3 : answerOptions.count)
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
    
    func applyAnswersAndScores(index: Int, isSelected: Bool) {
        switch answerType {
        case .multiSelect(let basicScore, let answerDisposition):
            let value: Float = answerDisposition == .negative ? -0.5 : 0.5
            if isSelected {
                answers[checklistItem.id]?.remove(index)
                scores[checklistItem.id] = Float(answers[checklistItem.id]?.count ?? 0) * value + basicScore
            } else {
                answers[checklistItem.id, default: Set()].insert(index)
                scores[checklistItem.id] = Float(answers[checklistItem.id]?.count ?? 0) * value + basicScore
            }
        case .multiChoices:
            if isSelected {
                answers[checklistItem.id] = nil
                scores[checklistItem.id] = Float(1)
            } else {
                answers[checklistItem.id] = Set([index])
                scores[checklistItem.id] = Float(index)
            }
        case .twoChoices:
            if isSelected {
                answers[checklistItem.id] = nil
                scores[checklistItem.id] = Float(1)
            } else {
                answers[checklistItem.id] = Set([index])
                scores[checklistItem.id] = Float(index == 1 ? 2 : 0)
            }
        }
    }
}
//
//#Preview {
//    ChecklistRowAnswerSectionView(answers: .constant([:]), scores: .constant([:]), checklistItem: ChecklistItem.checklistItems[0])
//}
