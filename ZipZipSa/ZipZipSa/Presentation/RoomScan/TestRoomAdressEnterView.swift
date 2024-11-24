//
//  TestEnterAddressView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI

struct TestRoomAdressEnterView: View {
    @State private var roomAddress: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Room Address", text: $roomAddress)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    // TODO: 현재위치(주소)를 가져와서 위의 텍스트필드에 넣음
                } label: {
                    Text("현재위치로 저장하기")
                        .underline()
                        .foregroundStyle(.gray)
                        .font(Font.system(size: 16))
                }
                
                Spacer()
                
                Button {
                    // TODO: 위의 주소를 모델에 저장한채로 RoomScanView로 이동
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.primary)
                        .frame(width: 300, height: 50)
                        .overlay(
                            Text("스캔하기")
                                .foregroundStyle(Color.white)
                        )
                }
            }
        }
    }
}

#Preview {
    TestRoomAdressEnterView()
}
