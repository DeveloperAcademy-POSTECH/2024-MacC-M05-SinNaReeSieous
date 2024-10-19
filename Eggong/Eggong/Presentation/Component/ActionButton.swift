//
//  ActionButton.swift
//  Eggong
//
//  Created by 조우현 on 10/20/24.
//

import SwiftUI

struct ActionButton: View {
    
    enum State {
        case enabled
        case disabled
        
        var foreground: Color {
            switch self {
            case .enabled: return .black
            case .disabled: return .white
            }
        }
        
        var background: Color {
            switch self {
            case .enabled: return .yellow
            case .disabled: return .gray
            }
        }
    }
    
    let state: State
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Label {
                Text("아끼는 공간 등록하기")
                    .font(.callout.bold())
            } icon: {
                Image(systemName: "heart.fill")
            }
            .font(.callout.bold())
            .foregroundStyle(state.foreground)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(state.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(state == .disabled)
    }
}

#Preview {
    VStack {
        ActionButton(state: .enabled, tapAction: {})
        ActionButton(state: .disabled, tapAction: {})
    }
}
