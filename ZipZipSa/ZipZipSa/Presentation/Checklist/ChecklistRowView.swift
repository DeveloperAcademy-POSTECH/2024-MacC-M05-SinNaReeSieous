//
//  ChecklistRowView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowView: View {
    let viewModel: ChecklistViewModel
    let checklistItem: ChecklistItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CategoryChipStack
            Question
            if captionType != .none {
                Caption
            }
            ChecklistRowAnswerSectionView(
                viewModel: viewModel,
                checklistItem: checklistItem
            )
            .padding(.top, 8)

        }
    }
}

private extension ChecklistRowView {

    var selectedCategory: [ChecklistCategory] {
        viewModel.selectedCategories
    }

    // MARK: - View

    var CategoryChipStack: some View {
        HStack(spacing: 8) {
            ForEach(chipData.indices, id:\.self) { index in
                if let chip = chipData[safe: index] {
                    CategoryChip(text: chip.text, color: chip.clolr)
                }
            }
        }
    }

    func CategoryChip(text: String, color: Color) -> some View {
        Text(text)
            .foregroundStyle(Color.ChecklistTag.colorGray)
            .applyZZSFont(zzsFontSet: .footnote)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
            }
    }

    var Question: some View {
        Text(checklistItem.question.question)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .headline)
    }

    var Caption: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(captionType == .remark ? .charChecklistRemark
                                         : .charChecklistCross)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 20)
            Text(captionText)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .caption1Regular)
                .lineLimit(nil)
        }
    }

    // MARK: - Computede Values

    var chipData: [(text: String, clolr: Color)] {
        var result: [(String, Color)]  = []
        if checklistItem.checkListType == .advanced {
            result.append((checklistItem.checkListType.text, Color.ChecklistTag.backgroundGray))
        }
        result += checklistItem.displayCategories
            .map { ($0.text, Color.ChecklistTag.backgroundYellow) }

        return result
    }

    var captionType: CaptionType {
        let isCrossTip = checklistItem.crossTip.keys.contains(where: {
            selectedCategory.contains($0)
        })

        if checklistItem.remark != nil {
            return .remark
        } else if isCrossTip {
            return .crossTip
        } else {
            return .none
        }
    }

    var captionText: String {
        switch captionType {
        case .remark:
            return checklistItem.remark ?? ""
        case .crossTip:
            var textData: [String?] = []
            selectedCategory.forEach {
                textData.append(checklistItem.crossTip[$0])
            }
            return textData.compactMap { $0 }.joined(separator: "\n")
        case .none:
            return ""
        }
    }
}

enum CaptionType {
    case remark
    case crossTip
    case none
}
