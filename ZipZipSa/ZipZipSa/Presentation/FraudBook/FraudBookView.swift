//
//  FraudBookView.swift
//  ZipZipSa
//

import SwiftUI

/// 전월세사기 도감 목록 화면. 카테고리 카드를 탭하면 상세(아코디언) 화면으로 이동한다.
struct FraudBookView: View {

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Title
                    CategoryCardList
                    Disclaimer
                }
            }
            .scrollIndicators(.never)
        }
        // 시스템 뒤로 버튼(ZZSNavigationBarAppearance)을 쓴다
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension FraudBookView {

    var Title: some View {
        Text(ZipLiteral.FraudBook.navigationTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }

    var CategoryCardList: some View {
        VStack(spacing: 16) {
            ForEach(FraudBookCategory.allCases) { category in
                NavigationLink(destination: FraudBookDetailView(category: category)) {
                    CategoryCard(for: category)
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }

    /// 도감이 참고용 일반 정보라는 안내. 내용을 가리지 않도록 작고 옅은 글씨로 둔다.
    var Disclaimer: some View {
        Text(ZipLiteral.FraudBook.disclaimer)
            .foregroundStyle(Color.Text.placeholder)
            // caption1Regular는 행간이 좁아(줄 높이 14pt) 여러 줄 안내문이 빽빽해 보인다.
            // applyZZSFont 안쪽에 둬야 폰트 세트의 lineSpacing보다 우선 적용된다.
            .lineSpacing(6)
            .applyZZSFont(zzsFontSet: .caption1Regular)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 40)
    }

    func CategoryCard(for category: FraudBookCategory) -> some View {
        let character = category.character

        return RoundedRectangle(cornerRadius: 24)
            .fill(Color.Button.secondaryRed)
            .frame(height: 130)
            .overlay(alignment: .bottomTrailing) {
                Image(character.imageName)
                    .resizable()
                    .frame(width: character.width, height: character.height)
                    .padding(.trailing, character.trailingInset)
            }
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(category.title)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .title2)
                    Text(category.subtitle)
                        .foregroundStyle(Color.secondary)
                        .applyZZSFont(zzsFontSet: .subheadlineBold)
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 16)
                .padding(.leading, 20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    NavigationStack {
        FraudBookView()
    }
}
