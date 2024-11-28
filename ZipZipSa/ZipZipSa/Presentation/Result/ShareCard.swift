//
//  ShareCard.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

struct ShareCard: View {
    @Binding var model: UIImage?
    
    var body: some View {
        VStack {
            // 사진뷰
            let image = Image(uiImage: UIImage(resource: .mainPicSample))
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
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack {
                            // TODO: 태그 컴포넌트화
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .frame(width: 50, height: 35)
                                .overlay(Text("태그"))
                            
                            Spacer()
                        }
                    }
                    .padding()
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
            if let modelData = model {
                Image(uiImage: modelData)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
            } else {
                Text("모델이 없습니다.")
                    .font(.headline)
                    .foregroundColor(.red)
            }
                
                Line()
                    .stroke(style: .init(dash: [2]))
                    .foregroundStyle(.gray)
                    .frame(height: 1)
                    .padding()
            
            // 주변시설 뷰
            HStack {
                ForEach(Facility.allCases, id: \.self) { facility in
                    Image(systemName: facility.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.clear, lineWidth: 1)
                .background(Color.Layer.first.clipShape(RoundedRectangle(cornerRadius: 20)))
        )
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    ShareCard()
//}
