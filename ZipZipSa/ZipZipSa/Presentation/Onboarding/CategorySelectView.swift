//
//  CategorySelectView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/24/24.
//

import SwiftUI

struct CategorySelectView: View {
    var body: some View {
        NavigationStack{
            VStack {
                HStack(alignment: .bottom) {
                    Image ("remark")
                        .resizable()
                        .frame(width: 62, height: 61)
                    
                    Text("아래 카테고리에 해당하는 필수 질문은 이미 있어요. 중요하게 보고 싶은 카테고리를 선택하시면, 더 꼼꼼히 확인할 수 있도록 추가 질문도 챙겨드릴게요.")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .font(Font.system (size: 14, weight: .semibold))
                        .background(Color.white)
                        .overlay {
                            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                                .stroke(.black, lineWidth: 1)
                        }
                        .padding(.leading, 18)
                        .padding(.trailing, 16)
                }
                .padding(.leading, 24)
                .padding(.bottom, 24)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width:UIScreen.screenSize.width - 32, height: 44)
                    .overlay {
                        HStack(alignment: .center) {
                            Text("집보는 시간")
                                .font(Font.system (size: 13, weight: .medium))
                            
                            Text("약 10분")
                                .font(Font.system (size: 16, weight: .semibold))
                        }
                    }
                
                NavigationLink(destination: CategorySelectView()) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.mint)
                        .frame(width:UIScreen.screenSize.width - 32, height: 44)
                        .overlay {
                                Text("약 10분")
                                    .font(Font.system (size: 16, weight: .semibold))
                        }
                }
                
            }
        }
    }
}

#Preview {
    CategorySelectView()
}
