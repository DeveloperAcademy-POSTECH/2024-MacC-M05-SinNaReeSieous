//
//  ViewedHomeCellView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/28/24.
//

import SwiftUI

struct ViewedHomeCellView: View {
    let home: HomeData
    
    var body: some View {
        if let homeImage = home.homeImage {
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
                            Text(home.homeName)
                                .multilineTextAlignment(.leading)
                                .applyZZSFont(zzsFontSet: .headline)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                            Spacer()
                            HStack(alignment: .bottom) {
                                if let locationText = home.locationText {
                                    Text(locationText)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 216, alignment: .leading)
                                        .applyZZSFont(zzsFontSet: .subheadlineBold)
                                        .foregroundStyle(Color.Text.onColorPrimary)
                                } else {
                                    Text("등록된 주소가 없어요")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(Color.Text.onColorPrimary)
                                        .applyZZSFont(zzsFontSet: .subheadlineBold)
                                        .frame(maxWidth: 216, alignment: .leading)
                                        .lineLimit(2)
                                }
                                Spacer()
                                if let homeCategoryType = home.homeCategoryType?.text {
                                    Text(homeCategoryType)
                                        .foregroundStyle(Color.Text.onColorSecondary)
                                        .applyZZSFont(zzsFontSet: .bodyBold)
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
                .background(Color.Button.tertiary)
                .clipped()
                .cornerRadius(16)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                        VStack(alignment: .leading) {
                            Text(home.homeName)
                                .multilineTextAlignment(.leading)
                                .applyZZSFont(zzsFontSet: .headline)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                            Spacer()
                            HStack(alignment: .bottom) {
                                if let locationText = home.locationText {
                                    Text(locationText)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 216, alignment: .leading)
                                        .applyZZSFont(zzsFontSet: .subheadlineBold)
                                        .foregroundStyle(Color.Text.onColorPrimary)
                                } else {
                                    Text("등록된 주소가 없어요")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(Color.Text.onColorPrimary)
                                        .applyZZSFont(zzsFontSet: .subheadlineBold)
                                        .frame(maxWidth: 216, alignment: .leading)
                                        .lineLimit(2)
                                }
                                Spacer()
                                if let homeCategoryType = home.homeCategoryType?.text {
                                    Text(homeCategoryType)
                                        .foregroundStyle(Color.Text.onColorSecondary)
                                        .applyZZSFont(zzsFontSet: .bodyBold)
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
