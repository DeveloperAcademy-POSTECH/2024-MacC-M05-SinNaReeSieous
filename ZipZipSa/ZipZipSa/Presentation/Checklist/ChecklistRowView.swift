//
//  ChecklistRowView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct ChecklistRowView: View {
    @Binding var selectedCategory: [ChecklistCategory]
    @Binding var answers: [UUID: Set<Int>]
    @Binding var scores: [UUID: Float]
    let checkListItem: ChecklistItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CategoryChipStack
            Question
            if captionType != .none {
                Caption
            }
            ChecklistRowAnswerSectionView(
                answers: $answers,
                scores: $scores,
                checkListItem: checkListItem
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
                let chip = chipData[index]
                CategoryChip(text: chip.text, color: chip.clolr)
            }
        }
    }
    
    func CategoryChip(text: String, color: Color) -> some View {
        Text(text)
            .foregroundStyle(Color.ChecklistTag.colorGray)
            .applyZZSFont(zzsFontSet: .caption1Regular)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
            }
    }
    
    var Question: some View {
        Text(checkListItem.question.question)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .headline)
    }
    
    var Caption: some View {
        HStack(alignment: .top) {
            Image(captionType == .remark ? .remark : .crossTip)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 20)
            Text(captionText)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .caption1Regular)
                .lineLimit(nil)
                .padding(.top, 4)
        }
    }
    
    // MARK: - Computede Values
    
    var chipData: [(text: String, clolr: Color)] {
        var result: [(String, Color)]  = []
        if checkListItem.checkListType == .advanced {
            result.append((checkListItem.checkListType.text, Color.ChecklistTag.backgroundGray))
        }
        if checkListItem.basicCategory.isSelectable {
            result.append((checkListItem.basicCategory.text, Color.ChecklistTag.backgroundYellow))
        }
        
        let crossChip = checkListItem.crossTip.keys
            .filter { selectedCategory.contains($0) }
            .map { ($0.text, Color.ChecklistTag.backgroundYellow) }
        
        result += crossChip
        
        return result
    }
    
    var captionType: CaptionType {
        let isCrossTip = checkListItem.crossTip.keys.contains(where: {
            selectedCategory.contains($0)
        })
        
        if checkListItem.remark != nil {
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
            return checkListItem.remark ?? ""
        case .crossTip:
            var textData: [String?] = []
            selectedCategory.forEach {
                textData.append(checkListItem.crossTip[$0])
            }
            return textData.compactMap { $0 }.joined(separator: "\n")
        case .none:
            return ""
        }
    }
    
    // MARK: - Action
    
}

enum CaptionType {
    case remark
    case crossTip
    case none
}


#Preview {
    ChecklistRowView(selectedCategory: .constant([]), answers: .constant([:]), scores: .constant([:]), checkListItem: ChecklistItem.checklistItems[0])
}
