//
//  TestFavAdressEnterView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI

struct TestFavAdressEnterView: View {
    @State private var favoriteAddress: String = ""
    
    var body: some View {
        VStack {
            TextField("Favorite Address", text: $favoriteAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // TODO: 여기에 검색 결과들이 뜰 예정
            Spacer()
            
            Button {
                // TODO: 위의 주소를 모델에 저장한채로 TestRoomAdressEnterView로 이동
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.primary)
                    .frame(width: 300, height: 50)
                    .overlay(
                        Text("다음")
                            .foregroundStyle(Color.white)
                    )
            }
        }
    }
}

#Preview {
    TestFavAdressEnterView()
}
