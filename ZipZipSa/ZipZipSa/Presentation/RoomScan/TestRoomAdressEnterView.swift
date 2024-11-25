//
//  TestEnterAddressView.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/25/24.
//

import SwiftUI
import SwiftData

struct TestRoomAdressEnterView: View {
    @Environment(\.modelContext) private var modelContext
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
            .onAppear {
                do {
                    // Fetch request를 통해 데이터 가져오기
                    let favoriteAddresses = try modelContext.fetch(FetchDescriptor<FavoriteAddress>())
                    print("저장된 FavoriteAddress 데이터:")
                    favoriteAddresses.forEach { address in
                        print("위도: \(address.latitude), 경도: \(address.longitude)")
                    }
                } catch {
                    print("데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    TestRoomAdressEnterView()
}
