//
//  FavoriteAddressEnterView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/25/24.
//

import SwiftUI

struct FavoriteAddressEnterView: View {
    @State var address: String = ""
    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                HStack(alignment: .bottom, spacing: 0) {
                    Image ("remark")
                        .resizable()
                        .frame(width: 62, height: 61)
                        .padding(0)
                    
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomTrailing: 10, topTrailing: 10))
                        .fill(Color.white)
                        .stroke(.black, lineWidth: 1)
                        .frame(height: 52)
                        .overlay {
                            Text("자주 가시는 곳의 주소를 알려주시면 도보와 대중교통으로 걸리는 시간을 알려드릴게요.")
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                        }
                        .padding(.leading, 10)
                }
                .padding(.bottom, 20)
                
                
                // 주소 검색이 되는지 안 되는지에 따라 쓰일지 안 쓰일지, 네비게이션 링크가 될지는 모르겠습니다만, 일단 구현은 했습니다.
                
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Button.enable)
                        .frame(width: UIScreen.screenSize.width - 32, height: 48)
                        .overlay {
                            HStack{
                                Button(action: {}) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color.Icon.tertiary)
                                        .padding(.leading, 10)
                                }
                                
                                TextField("주소를 알려주세요 (예. 학교, 회사)", text: $address)
                                    .foregroundColor(Color.Text.placeholder)
                            }
                        }
                }
                
                NavigationLink(destination: MainView()) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.Button.primaryBlue)
                        .frame(width:UIScreen.screenSize.width - 32, height: 44)
                        .overlay {
                            Text("완료")
                                .applyZZSFont(zzsFontSet:.bodyBold)
                                .foregroundStyle(Color.Text.primary)
                        }
                }
                .padding(.top, 419)
                
                NavigationLink(destination: MainView()) {
                    
                    Text("나중에 할래요")
                        .applyZZSFont(zzsFontSet:.bodyBold)
                        .foregroundStyle(Color.Text.tertiary)
                }
                .padding(.top, 22)
                
            }
            .padding(.horizontal, 16)
            .accentColor(.black)
        }
    }
}

#Preview {
    FavoriteAddressEnterView()
}
