//
//  ResultCardView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import Vision

struct ResultCardView: View {
    
    @State private var card: UIImage = UIImage()
    @Binding var hasRoomModel: Bool
    
    var room: SampleRoom
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ShareCard(hasRoomModel: $hasRoomModel, room: room)
                        .padding(.bottom, 20)
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        DispatchQueue.main.async {
                                            // 캡처 크기를 동적으로 설정
                                            let size = CGSize(width: proxy.size.width, height: proxy.size.height + 20)
                                            card = ShareCard(hasRoomModel: $hasRoomModel, room: room)
                                                .asUIImage(size: size)
                                        }
                                    }
                            }
                        )
                    
                    Button {
                        
                    } label: {
                        Text("상세보기")
                            .underline()
                            .foregroundStyle(.gray)
                            .font(Font.system(size: 16))
                    }
                    .padding(.bottom, 30)
                    
                    ShareLink(item: Image(uiImage: card), preview: SharePreview("집 요약 카드 공유", icon: "AppIcon")) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.primary)
                            .frame(width: 300, height: 50)
                            .overlay(
                                Text("공유하기")
                                    .foregroundStyle(Color.white)
                            )
                    }
                }
            }
            .navigationTitle("집 요약카드예요")
        }
    }
}

//#Preview {
//    SpaceDetailVIew()
//}
