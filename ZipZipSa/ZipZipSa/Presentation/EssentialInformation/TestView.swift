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
    @State var selectedHomeCategory: HomeCategory? = nil
    @State var selectedHomeRentalType: HomeRentalType? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationTitle
                NameSection
                AddressSection
                HomePhotoSection
                HomeCategorySection
                HomeRentalTypeSection
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
            .padding(.bottom, 32)
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
        .padding(.bottom, 32)
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
        .padding(.bottom, 24)
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
                    .foregroundStyle(Color.Icon.tertiary)
                    .applyZZSFont(zzsFontSet: .caption1Regular)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.Icon.tertiary)
                            .frame(height: 0.6)
                    }
            }
        }
    }
    
    // HomePhotoSection
    
    var HomePhotoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "건물 외관")
            GetPhotoButton
        }
        .padding(.bottom, 32)
    }
    
    var GetPhotoButton: some View {
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
    
    // HomeCategorySection
    
    var HomeCategorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "유형")
            HomeCategoryButtonStack
        }
        .padding(.bottom, 24)
    }
    
    var HomeCategoryButtonStack: some View {
        HStack(spacing: 8) {
            ForEach(HomeCategory.allCases.indices, id: \.self) { index in
                let category = HomeCategory.allCases[index]
                Button {
                    selectedHomeCategory = selectedHomeCategory == category ? nil : category
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(selectedHomeCategory == category ? Color.Button.secondaryYellow : Color.Button.enable)
                    .frame(height: 40)
                    .overlay {
                        Text(category.text)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                }
            }
        }
    }
    
    // HomeCategorySection
    
    var HomeRentalTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "계약형태")
            HomeRentalTypeButtonStack
        }
        .padding(.bottom, 24)
    }
    
    var HomeRentalTypeButtonStack: some View {
        HStack(spacing: 8) {
            ForEach(HomeRentalType.allCases.indices, id: \.self) { index in
                let rentalType = HomeRentalType.allCases[index]
                Button {
                    selectedHomeRentalType = selectedHomeRentalType == rentalType ? nil : rentalType
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(selectedHomeRentalType == rentalType ? Color.Button.secondaryYellow : Color.Button.enable)
                    .frame(height: 40)
                    .overlay {
                        Text(rentalType.text)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
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
