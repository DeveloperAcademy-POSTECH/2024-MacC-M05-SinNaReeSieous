//
//  ChecklistTabView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

struct ChecklistTabView: View {
    @Binding var selectedSpaceType: SpaceType
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(SpaceType.allCases.indices, id: \.self) { index in
                let type = SpaceType.allCases[index]
                TopSpaceButton(type: type)
            }
        }
        .padding([.horizontal, .bottom], 16)
        .background(Color.Background.primary)
    }
}

private extension ChecklistTabView {
    
    // MARK: - View
    
    func TopSpaceButton(type: SpaceType) -> some View {
        Button {
            changeSpaceType(to: type)
        } label: {
            HStack(spacing: 0) {
                Spacer()
                Text(type.text)
                    .foregroundStyle(type == selectedSpaceType ? Color.Text.onColorPrimary
                                                               : Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    .fixedSize()
                Spacer()
            }
            .padding(.vertical, 10)
            .background {
                UnevenRoundedRectangle(
                    cornerRadii: RectangleCornerRadii(
                        bottomLeading: 16,
                        bottomTrailing: 16,
                        topTrailing: 16)
                )
                .fill(type == selectedSpaceType ? Color.Button.tertiary
                                                : Color.Button.enable)
            }
        }
    }
    
    // MARK: - Action
    
    func changeSpaceType(to selectedSpaceType: SpaceType) {
        self.selectedSpaceType = selectedSpaceType
    }
}



#Preview {
    ChecklistTabView(selectedSpaceType: .constant(.exterior))
}
