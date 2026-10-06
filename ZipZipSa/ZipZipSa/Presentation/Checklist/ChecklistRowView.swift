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

    /// 온보딩(관심 카테고리 선택)이 사라지면서 체크리스트에서는 카테고리·추가 칩을
    /// 노출하지 않는다. 되살릴 수 있도록 계산 로직(chipData)은 그대로 둔다.
    /// 커스텀 체크리스트 편집 화면은 칩을 계속 보여준다.
    private let showsCategoryChips = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showsCategoryChips {
                CategoryChipStack
            }
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
        if checklistItem.remark != nil {
            return .remark
        } else if !checklistItem.crossTip.isEmpty {
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
            // 관심 카테고리 선택이 사라져 선택 여부와 무관하게 팁을 노출한다.
            // 여러 카테고리가 같은 통합 문구를 공유하므로 중복 문구는 한 번만 노출
            var textData: [String] = []
            ChecklistCategory.allCases.forEach {
                if let tip = checklistItem.crossTip[$0], !textData.contains(tip) {
                    textData.append(tip)
                }
            }
            return textData.joined(separator: "\n")
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
