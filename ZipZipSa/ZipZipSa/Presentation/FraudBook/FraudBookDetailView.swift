//
//  FraudBookDetailView.swift
//  ZipZipSa
//

import SwiftUI

/// 전월세사기 도감 카테고리 상세 화면.
/// 아코디언 목록으로, 진입 시 가장 상단 항목만 열려 있고 나머지는 닫혀 있다.
struct FraudBookDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let category: FraudBookCategory
    private let sections: [FraudBookSection]
    @State private var expandedSectionIDs: Set<String>

    init(category: FraudBookCategory) {
        self.category = category
        let sections = category.sections
        self.sections = sections
        _expandedSectionIDs = State(initialValue: Set(sections.prefix(1).map(\.id)))
    }

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Title
                    if sections.isEmpty {
                        EmptyContent
                    } else {
                        SectionCardList
                    }
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

private extension FraudBookDetailView {

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
        Text(category.title)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }

    var SectionCardList: some View {
        VStack(spacing: 12) {
            ForEach(sections) { section in
                SectionCard(for: section)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }

    var EmptyContent: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.Background.disabled)
            .frame(height: 208)
            .overlay {
                Text(ZipLiteral.FraudBook.emptyContent)
                    .foregroundStyle(Color.Text.tertiary)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 12)
            .padding(.horizontal, 16)
    }

    func SectionCard(for section: FraudBookSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                toggle(section)
            } label: {
                HStack(spacing: 8) {
                    Text(section.title)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: isExpanded(section) ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.Button.tertiary)
                        .applyZZSFont(zzsFontSet: .iconBody)
                }
                .padding(16)
                .contentShape(Rectangle())
            }

            if isExpanded(section) {
                Text(section.content)
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Background.enable)
        }
    }

    // MARK: - Action

    func isExpanded(_ section: FraudBookSection) -> Bool {
        expandedSectionIDs.contains(section.id)
    }

    func toggle(_ section: FraudBookSection) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if isExpanded(section) {
                expandedSectionIDs.remove(section.id)
            } else {
                expandedSectionIDs.insert(section.id)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FraudBookDetailView(category: .firstCheck)
    }
}
