//
//  ChecklistRowAnswerSectionView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowAnswerSectionView: View {
    let viewModel: ChecklistViewModel
    let checklistItem: ChecklistItem

    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 8

    var body: some View {
        LazyVGrid(columns: columns, spacing: verticalSpacing) {
            ForEach(answerOptions, id: \.self) { value in
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
        let isSelected = viewModel.isSelected(item: checklistItem, index: index)
        return Button {
            viewModel.toggleAnswer(item: checklistItem, index: index)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? color : Color.Button.enable)
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
}
