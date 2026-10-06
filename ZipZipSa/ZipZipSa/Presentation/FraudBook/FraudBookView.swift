//
//  FraudBookView.swift
//  ZipZipSa
//

import SwiftUI

/// 전월세사기 도감 목록 화면. 카테고리 카드를 탭하면 상세(아코디언) 화면으로 이동한다.
struct FraudBookView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Title
                    CategoryCardList
                }
            }
            .scrollIndicators(.never)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton
            }
        }
    }
}

private extension FraudBookView {

    var BackButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .applyZZSFont(zzsFontSet: .iconTitle1)
                Text(ZipLiteral.FraudBook.back)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Button.tertiary)
        }
    }

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
        .padding(.top, 12)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }

    func CategoryCard(for category: FraudBookCategory) -> some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.Button.secondaryRed)
            .frame(height: 130)
            .overlay(alignment: .bottomTrailing) {
                Image(category.characterImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 96)
                    .padding(.trailing, 20)
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
