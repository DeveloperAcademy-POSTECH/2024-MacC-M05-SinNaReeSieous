//
//  PlaceDetailFooterView.swift
//  Eggong
//
//  Created by 조우현 on 10/19/24.
//

import SwiftUI

struct PlaceDetailFooterView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("더 자세한 정보")
                .font(.title2.bold())
                .padding(.bottom, 10)
            
            HStack {
                Text("네이버지도")
                    .font(.caption.bold())
                
                Spacer()
                
                Button {
                    // TODO: 네이버지도로 이동
                } label: {
                    Text("바로가기").underline()
                        .foregroundStyle(.gray)
                        .font(.caption.bold())
                }
            }
            
            HStack {
                Text("카카오맵")
                    .font(.caption.bold())
                
                Spacer()
                
                Button {
                    // TODO: 카카오맵으로 이동
                } label: {
                    Text("바로가기").underline()
                        .foregroundStyle(.gray)
                        .font(.caption.bold())
                }
            }
            
            ActionButton(state: .enabled, tapAction: {})
                .padding(.top, 40)
                .padding(.bottom, 30)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    PlaceDetailFooterView()
}
