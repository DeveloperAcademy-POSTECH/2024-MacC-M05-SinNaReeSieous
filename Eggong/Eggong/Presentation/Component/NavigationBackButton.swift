//
//  NavigationBackButton.swift
//  Eggong
//
//  Created by 조우현 on 10/19/24.
//

import SwiftUI

struct NavigationBackButton: View {
    
    let tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    NavigationBackButton{}
}
