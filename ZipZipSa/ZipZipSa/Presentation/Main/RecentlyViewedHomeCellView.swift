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
        if let image = home.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenSize.width / 375 * 220, height: UIScreen.screenSize.height / 812 * 208)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                        VStack(alignment: .leading) {
                            HStack(alignment: .top, spacing:0) {
                                Text(home.title)
                                    .foregroundStyle(Color.Tag.backgroundGray)
                                    .applyZZSFont(zzsFontSet: .subheadlineBold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.Tag.backgroundWhite)
                                    }
                                Spacer()
                                if let rentType = home.rentType {
                                    Text(rentType)
                                        .foregroundStyle(Color.Text.onColorSecondary)
                                        .applyZZSFont(zzsFontSet: .caption1Bold)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                                        }
                                    
                                }
                            }
                            
                            Spacer()
                            if let address = home.address {
                                Text(address)
                                    .foregroundStyle(Color.Text.onColorPrimary)
                                    .applyZZSFont(zzsFontSet: .caption1Bold)
                                    .frame(maxWidth: 168, alignment: .leading)
                                    .lineLimit(2)
                            }
                        }
                        .padding(8)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Image("charResultCard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .frame(width: UIScreen.screenSize.width / 375 * 220, height: UIScreen.screenSize.height / 812 * 208)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                        VStack(alignment: .leading) {
                            HStack(alignment: .top, spacing:0) {
                                Text(home.title)
                                    .foregroundStyle(Color.Tag.backgroundGray)
                                    .applyZZSFont(zzsFontSet: .subheadlineBold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.Tag.backgroundWhite)
                                    }
                                Spacer()
                                if let rentType = home.rentType {
                                    Text(rentType)
                                        .foregroundStyle(Color.Text.onColorSecondary)
                                        .applyZZSFont(zzsFontSet: .caption1Bold)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background {
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                                        }
                                    
                                }

                            }
                            
                            Spacer()
                            
                            if let address = home.address {
                                Text(address)
                                    .foregroundStyle(Color.Text.onColorPrimary)
                                    .applyZZSFont(zzsFontSet: .caption1Bold)
                                    .frame(maxWidth: 168, alignment: .leading)
                                    .lineLimit(2)
                            }
                        }
                        .padding(8)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
