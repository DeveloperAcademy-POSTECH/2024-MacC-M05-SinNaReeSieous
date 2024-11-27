//
//  TestView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import SwiftUI

struct TestView: View {
    @State var houseName: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                NavigationTitle
                HouseName
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
    
    var HouseName: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "집 별명")
            TextField(text: $houseName) {
                Text("\(basicHouseName)")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
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
