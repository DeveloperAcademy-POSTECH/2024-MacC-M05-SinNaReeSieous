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
            ZStack {
                Color.Background.primary
                    .ignoresSafeArea()
                VStack  {
                    ZipZipSaTip
                    RequiredTime
                    CategoryView(totalTime: $totalTime, currentMessage: $currentMessage)
                    BottomButton
                }
            }
            .accentColor(Color.Button.tertiary)
            .navigationBarBackButtonHidden()
        }
    }
}

private extension CategorySelectView {
    
    var ZipZipSaTip: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("basicYongboogiHeadColor")
                .resizable()
                .frame(width: 62, height: 61)
                .padding(.leading, 8)
                .padding(.trailing, 18)
            
            Group {
                if currentMessage.isEmpty {
                    Text(ZipLiteral.CategorySelect.defaultMessage)
                } else {
                    Text(currentMessage)
                }
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .subheadlineBold)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: UIScreen.screenSize.width / 375 * 255, alignment: .bottomLeading)
            .background {
                GeometryReader { geometry in
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(
                        topLeading: 10,
                        bottomTrailing: 10,
                        topTrailing: 10
                    ))
                    .stroke(.black, lineWidth: 1)
                    .fill(Color.Layer.first)
                    .frame(
                        width: UIScreen.screenSize.width / 375 * 255,
                        height: geometry.size.height
                    )
                }
            }
        }
        .frame(width: UIScreen.screenSize.width - 32, height: UIScreen.screenSize.height / 812 * 116, alignment: .bottom)
        .padding(.bottom, 24)
        .padding(.top, 24)
    }
    
    var RequiredTime: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.Background.secondary)
            .frame(width:UIScreen.screenSize.width - 32, height: 44)
            .overlay {
                HStack(alignment: .center) {
                    Text(ZipLiteral.CategorySelect.requiredTime)
                        .foregroundStyle(Color.Text.primary)
                        .font(Font.system (size: 13, weight: .medium))
                    
                    Text("약 \(totalTime)분")
                        .foregroundStyle(Color.Text.primary)
                        .font(Font.system (size: 16, weight: .semibold))
                }
            }
            .padding(.bottom, 32)
    }
    
    var BottomButton: some View {
        NavigationLink(destination: FavoriteAddressEnterView()) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.primaryBlue)
                .frame(width:UIScreen.screenSize.width - 32, height: 53)
                .overlay {
                    Text(ZipLiteral.CategorySelect.done)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet:.bodyBold)
                }
        }
        .padding(.top, 24)
        .padding(.bottom, 30)
    }
}

#Preview {
    CategorySelectView()
}
