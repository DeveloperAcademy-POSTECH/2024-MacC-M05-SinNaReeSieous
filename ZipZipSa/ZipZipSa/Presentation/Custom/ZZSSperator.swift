//
//  ZZSSperator.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/29/24.
//

import SwiftUI

struct ZZSSperator: View {
    var color: Color = Color.Additional.seperator

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}

#Preview {
    ZZSSperator()
}
