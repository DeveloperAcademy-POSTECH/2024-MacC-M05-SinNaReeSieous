//
//  RecentlyViewedHomeCellView.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/29/24.
//

import SwiftUI

struct RecentlyViewedHomeCellView: View {
    let home: HomeData
    
    var body: some View {
        if let image = home.homeImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenSize.width / 375 * 220, height: UIScreen.screenSize.height / 812 * 208)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                       
                    }
                }
                .overlay {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 0) {
                            Text(home.homeName)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                                
                            Spacer(minLength: 0)
                            if let homeType = home.homeCategoryType?.text {
                                Text(homeType)
                                    .foregroundStyle(Color.Text.onColorSecondary)
                                    .applyZZSFont(zzsFontSet: .subheadlineBold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                                    }
                                    .frame(width: 61, alignment: .trailing)
                                    .padding(.leading, 6)
                            } else {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 61, height: 2)
                                    .padding(.leading, 6)
                            }
                        }
                        
                        Spacer()
                        if let locationText = home.locationText {
                            Text(locationText)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Text.onColorPrimary)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .lineLimit(2)
                        } else {
                            Text("등록된 주소가 없어요")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Text.onColorPrimary)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .lineLimit(2)
                        }
                    }
                    .padding(8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        } else {
            Image("charResultCard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .frame(width: UIScreen.screenSize.width / 375 * 220, height: UIScreen.screenSize.height / 812 * 208)
                .background(Color.Button.tertiary)
                .overlay {
                    ZStack {
                        Color.Additional.seperator.opacity(0.3)
                        Color.black.opacity(0.4)
                       
                    }
                }
                .overlay {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 0) {
                            Text(home.homeName)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Tag.backgroundGray)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.Tag.backgroundWhite)
                                }
                                
                            Spacer(minLength: 0)
                            if let homeType = home.homeCategoryType?.text {
                                Text(homeType)
                                    .foregroundStyle(Color.Text.onColorSecondary)
                                    .applyZZSFont(zzsFontSet: .subheadlineBold)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                                    }
                                    .frame(width: 61, alignment: .trailing)
                                    .padding(.leading, 6)
                            } else {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 61, height: 2)
                                    .padding(.leading, 6)
                            }
                        }
                        
                        Spacer()
                        if let locationText = home.locationText {
                            Text(locationText)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Text.onColorPrimary)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .lineLimit(2)
                        } else {
                            Text("등록된 주소가 없어요")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.Text.onColorPrimary)
                                .applyZZSFont(zzsFontSet: .subheadlineBold)
                                .lineLimit(2)
                        }
                    }
                    .padding(8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
