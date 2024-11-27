//
//  TestView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import SwiftUI

struct TestView: View {
    @State var homeName: String = ""
    @State var address: String = ""
    @State var imageExist: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                NavigationTitle
                NameSection
                AddressSection
                HomePhotoSection
            }
            .padding(.horizontal, 16)
        }
        .background(Color.Background.primary)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}

private extension TestView {
    
    // MARK: - View
    
    var NavigationTitle: some View {
        Text("기본정보를 알려주세요")
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
    }
    
    // NameSection
    
    var NameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "집 별명")
            TextField(text: $homeName) {
                Text(basicHouseName)
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
        }
    }
    
    // AddressSection
    
    var AddressSection: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                SectionTitle(text: "주소")
                Spacer()
            }
            SearchAddressButton
            GetCurrentAddressButton
        }
    }
    
    var SearchAddressButton: some View {
        Button {
            print("주소 검색뷰로 이동")
        } label: {
            HStack {
                Text("주소를 입력해 주세요")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
            .padding(.top, 3)
        }
    }
    
    var GetCurrentAddressButton: some View {
        Button {
            print("get Current Address")
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.Icon.tertiary)
                    .applyZZSFont(zzsFontSet: .iconSubheadline)
                    .padding(.horizontal, 2)
                Text("현재위치로 저장하기")
                    .underline()
                    .foregroundStyle(Color.Icon.tertiary)
                    .applyZZSFont(zzsFontSet: .caption1Regular)
            }
        }
    }
    
    // HomePhotoSection
    
    var HomePhotoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "건물 외관")
            Button {
                print("Get Photo")
                imageExist.toggle()
            } label: {
                if imageExist {
                    Image(.mainPicSample)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.screenSize.width-32, height: (UIScreen.screenSize.width-32)/343*144)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                                            bottomTrailing: 16,
                                                                                            topTrailing: 16)))
                } else {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(Color.Button.enable)
                    .frame(width: UIScreen.screenSize.width-32, height: (UIScreen.screenSize.width-32)/343*144)
                    .overlay {
                        Image(systemName: "photo.badge.plus.fill")
                            .foregroundStyle(Color.Icon.secondary)
                            .applyZZSFont(zzsFontSet: .iconTitle1)
                    }
                }
            }
        }
    }
    
    
    
    func SectionTitle(text: String) -> some View {
        Text(text)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyBold)
    }
    
    
    // MARK: - Computed Values
    
    var basicHouseName: String {
        "1번째 집"
    }
}

#Preview {
    TestView()
}
