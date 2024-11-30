//
//  ViewedHomeCellView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/28/24.
//

import SwiftUI

struct ViewedHomeCellView: View {
    @Binding var home: ViewedHome
    
    var body: some View {
        if let homeImage = home.image {
            Image(uiImage: homeImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenSize.width / 375 * 343, height: UIScreen.screenSize.height / 812 * 208 )
                .clipped()
                .cornerRadius(16)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                        VStack(alignment: .leading) {
                            Text(home.title)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                            
                            Spacer()
                            HStack {
                                if let address = home.address {
                                    Text(address)
                                        .frame(width: 216, alignment: .leading)
                                        .applyZZSFont(zzsFontSet: .caption1Bold)
                                        .foregroundStyle(Color.Text.onColorPrimary)
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                }
                .frame(width: UIScreen.screenSize.width / 375 * 343)
                .cornerRadius(16)
        } else {
            Image("charResultCard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .frame(width: UIScreen.screenSize.width / 375 * 343, height: UIScreen.screenSize.height / 812 * 208 )
                .clipped()
                .cornerRadius(16)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                        VStack(alignment: .leading) {
                            Text(home.title)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                            
                            Spacer()
                            HStack {
                                if let address = home.address {
                                    Text(address)
                                        .frame(width: 216, alignment: .leading)
                                        .applyZZSFont(zzsFontSet: .caption1Bold)
                                        .foregroundStyle(Color.Text.onColorPrimary)
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                }
                .frame(width: UIScreen.screenSize.width / 375 * 343)
                .cornerRadius(16)
        }
    }
}
