//
//  CategorySelectView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/24/24.
//

import SwiftUI

struct CategorySelectView: View {
    
    @State private var totalTime: Int = 10
    @State private var currentMessage: String = ""
    
    var body: some View {
        NavigationStack{
            VStack  {
                ZipZipSaTip
                Spacer()
                RequiredTime
                CategoryView(totalTime: $totalTime, currentMessage: $currentMessage)
                BottomButton
                
            }
        }
        .accentColor(Color.Button.tertiary)
        .navigationBarBackButtonHidden()
    }
}

private extension CategorySelectView {
    
    var ZipZipSaTip: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("remark")
                .resizable()
                .frame(width: 62, height: 61)
                .padding(.leading, 8)
                .padding(.trailing, 18)
            
            Group {
                if currentMessage.isEmpty {
                    Text("아래 카테고리에 해당하는 필수 질문은 이미 있어요. 중요하게 보고 싶은 카테고리를 선택하시면, 더 꼼꼼히 확인할 수 있도록 추가 질문도 챙겨드릴게요.")
                } else {
                    Text(currentMessage)
                }
            }
            .applyZZSFont(zzsFontSet: .subheadlineBold)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: UIScreen.screenSize.width / 375 * 255, alignment: .bottom)
            .overlay {
                GeometryReader { geometry in
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(
                        topLeading: 10,
                        bottomTrailing: 10,
                        topTrailing: 10
                    ))
                    .stroke(.black, lineWidth: 1)
                    .frame(
                        width: UIScreen.screenSize.width / 375 * 255,
                        height: geometry.size.height
                    )
                }
            }
            
        }
        .frame(width: UIScreen.screenSize.width - 32, height: UIScreen.screenSize.height / 812 * 116)
        .border(.black, width: 1)
        .padding(.bottom, 24)
    }
    
    var RequiredTime: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(width:UIScreen.screenSize.width - 32, height: 44)
            .overlay {
                HStack(alignment: .center) {
                    Text("집보는 시간")
                        .font(Font.system (size: 13, weight: .medium))
                    
                    Text("약 \(totalTime)분")
                        .font(Font.system (size: 16, weight: .semibold))
                }
            }
            .padding(.bottom, 32)
    }
    
    var BottomButton: some View {
        
        NavigationLink(destination: FavoriteAddressEnterView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.primaryBlue)
                .frame(width:UIScreen.screenSize.width - 32, height: 44)
                .overlay {
                    Text("완료")
                        .applyZZSFont(zzsFontSet:.bodyBold)
                        .foregroundStyle(Color.Text.primary)
                }
        }
        .padding(.top, 24)
        .padding(.bottom, 30)
    }
    
}

#Preview {
    CategorySelectView()
}
