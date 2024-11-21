//
//  CheckListRowView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/20/24.
//

import SwiftUI

struct CheckListRowView: View {
    @Binding var selectedCategory: [CheckListCategory]
    @Binding var answers: [UUID: Set<Int>]
    @Binding var scores: [UUID: Float]
    let checkListItem: CheckListItem
    
    var body: some View {
        VStack(alignment: .leading) {
            CategoryChipStack
            Question
            if captionType != .none {
                Caption
            }
            CheckListRowAnswerSectionView(answers: $answers,
                                          scores: $scores,
                                          checkListItem: checkListItem)
        }
    }
}

private extension CheckListRowView {
    
    // MARK: - View
    
    var CategoryChipStack: some View {
        HStack {
            ForEach(chipData.indices, id:\.self) { index in
                let chip = chipData[index]
                CategoryChip(text: chip.text, color: chip.clolr)
            }
        }
    }
    
    func CategoryChip(text: String, color: Color) -> some View {
        Text(text)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                    .fill(color)
            }
    }
    
    var Question: some View {
        Text(checkListItem.question.question)
            .bold()
            .font(.title3)
    }
    
    var Caption: some View {
        HStack(alignment: .top) {
            Image(captionType == .remark ? .remark : .crossTip)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 20)
            Text(captionText)
                .lineLimit(nil)
                .font(.caption)
                .padding(.top, 4)
        }
    }
    
    // MARK: - Computede Values
    
    var chipData: [(text: String, clolr: Color)] {
        var result: [(String, Color)]  = []
        if checkListItem.checkListType == .advanced {
            result.append((checkListItem.checkListType.text, .gray))
        }
        if checkListItem.basicCategory.isSelectable {
            result.append((checkListItem.basicCategory.text, .green))
        }
       
        let crossChip = checkListItem.crossTip.keys.filter { selectedCategory.contains($0) }.map { ($0.text, Color.green) }
        
        result += crossChip
        
        return result
    }
    
    var captionType: captionType {
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

#Preview {
    CheckListRowView(selectedCategory: .constant([]), answers: .constant([:]), scores: .constant([:]), checkListItem: CheckListItem.checkListItems[0])
}
