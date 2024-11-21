//
//  ShareCard.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCard: View {
    @Binding var hasRoomModel: Bool
    var room: SampleRoom
    
    var body: some View {
        VStack {
            // 사진뷰
            let image = Image(uiImage: room.mainPicture ?? UIImage(resource: .mainPicSample))
                .resizable()
                .scaledToFill()
            
            image
                .frame(height: 340)
                .overlay(Color.black.opacity(0.3))
                .overlay {
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.black)
                            .frame(width: 60, height: 30)
                            .overlay {
                                Text("집 별명")
                                    .foregroundStyle(.white)
                            }
                        
                        HStack {
                            Text("집 주소 집 주소 집 주소 집 주소 집 주소 집 주소")
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .font(.title3.bold())
                            
                            Button {
                                // TODO: 복사하기
                            } label: {
                                Image(systemName: "square.on.square")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        // TODO: 태그 컴포넌트화
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(width: 50, height: 35)
//                            .padding()
                            .overlay(Text("태그"))
                    }
                    .padding(.horizontal, 5)
                    .padding(.vertical, 10)
                }
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, topTrailing: 20)))
            
            Spacer()
                .frame(minWidth: 0, maxWidth: 10)
            
            // 카테고리 뷰
            Group {
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
            }
            
            Line()
                .stroke(style: .init(dash: [2]))
                .foregroundStyle(.gray)
                .frame(height: 1)
                .padding()
            
            // 필수체크 뷰
            Group {
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
                Text("TEST TEXT")
            }
            
            Line()
                .stroke(style: .init(dash: [2]))
                .foregroundStyle(.gray)
                .frame(height: 1)
                .padding()
            
            // 집 구조 뷰
            if hasRoomModel, let modelData = room.model, let uiImage = UIImage(data: modelData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
                
                Line()
                    .stroke(style: .init(dash: [2]))
                    .foregroundStyle(.gray)
                    .frame(height: 1)
                    .padding()
            }
            
            // 주변시설 뷰
            HStack {
                Circle().frame(width: 30, height: 30)
                Circle().frame(width: 30, height: 30)
                Circle().frame(width: 30, height: 30)
                
                Spacer()
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
                .background(Color.pink.opacity(0.05).clipShape(RoundedRectangle(cornerRadius: 20)))
        )
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    ShareCard()
//}
