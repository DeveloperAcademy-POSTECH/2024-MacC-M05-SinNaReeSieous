//
//  RecentlyViewedHomeCellView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/29/24.
//

import SwiftUI

struct RecentlyViewedHomeCellView: View {
    @Binding var home: ViewedHome
    
    var body: some View {
        Image(home.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.screenSize.width / 375 * 220, height: UIScreen.screenSize.height / 812 * 208)
            .overlay {
                ZStack {
                    Color.Additional.seperator.opacity(0.3)
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.4)]),
                                   startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .leading) {
                        Text(home.title)
                            .applyZZSFont(zzsFontSet: .subheadlineBold)
                            .foregroundStyle(Color.Tag.colorGray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background {
                                Rectangle()
                                    .fill(Color.Tag.backgroundGray)
                                    .cornerRadius(8)
                            }
                        
                        Spacer()
                        
                        Text(home.address)
                            .foregroundStyle(Color.Text.onColorPrimary)
                            .applyZZSFont(zzsFontSet: .caption1Bold)
                            .frame(maxWidth: 168, alignment: .leading)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
