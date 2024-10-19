//
//  PlaceDetailDescriptionView.swift
//  Eggong
//
//  Created by 조우현 on 10/19/24.
//

import SwiftUI

struct PlaceDetailDescriptionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("카페를 어떤 공간으로")
                Text("만들고 싶으셨나요?")
            }
            .font(.title2.bold())
            
            Text("저는 이 카페가 사람들이 와서 편하게 수다 떨고, 웃고, 함께 시간을 보낼 수 있는 공간이었으면 좋겠어요. 커피나 음료는 물론 중요하지만, 이곳은 대화하고 어울리는 게 더 큰 의미라고 생각하거든요. 혼자 조용히 책을 읽는 그런 카페가 아니라, 친구들끼리 모여서 시끌벅적하게 이야기 나누고, 웃음소리로 가득 찬 그런 분위기를 만들고 싶어요.")
                .padding(.top, 8)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    PlaceDetailDescriptionView()
}
