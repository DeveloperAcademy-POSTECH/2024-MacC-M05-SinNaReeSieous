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
        TopSpaceButtonStack
    }
}

private extension ChecklistTabView {
    var TopSpaceButtonStack: some View {
        HStack {
            ForEach(SpaceType.allCases.indices, id: \.self) { index in
                let type = SpaceType.allCases[index]
                TopSpaceButton(type: type)
            }
        }
    }
    
    func TopSpaceButton(type: SpaceType) -> some View {
        Button {
            print("Change Space Type: \(type.text)")
            selectedSpaceType = type
        } label: {
            Text(type.text)
                .foregroundStyle(.black)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 15,
                                     style: .continuous)
                    .fill(type == selectedSpaceType ? Color.blue
                          : Color.white)
                }
        }
    }
}

#Preview {
    ChecklistTabView(selectedSpaceType: .constant(.exterior))
}
