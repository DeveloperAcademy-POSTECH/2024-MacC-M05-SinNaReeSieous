//
//  ChecklistTemplateSwitchSheet.swift
//  ZipZipSa
//

import SwiftUI
import SwiftData

/// 집 보기 세션 도중 사용할 체크리스트를 바꾸는 시트.
/// 대표 설정은 건드리지 않고 이 세션의 질문 세트만 전환한다.
struct ChecklistTemplateSwitchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]

    /// 현재 세션에서 사용 중인 템플릿 id. nil이면 기본 체크리스트.
    let currentTemplateID: UUID?
    let onSelect: (ChecklistTemplateData?) -> Void

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Title
                    TemplateCardList
                }
            }
            .scrollIndicators(.never)
        }
    }
}

private extension ChecklistTemplateSwitchSheet {

    var user: User? { users.first }

    var defaultQuestionCount: Int {
        QuestionProvider.questions(selectedCategories: user?.favoriteCategories ?? []).count
    }

    // MARK: - View

    var Title: some View {
        Text(ZipLiteral.ChecklistTemplate.switchTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .padding(.bottom, 12)
    }

    /// 사용 중인 체크리스트는 항상 맨 위에 노출한다.
    var rows: [ChecklistTemplateRow] {
        ChecklistTemplateRow.ordered(
            templates: user?.templates ?? [],
            markedID: currentTemplateID
        )
    }

    var TemplateCardList: some View {
        VStack(spacing: 10) {
            ForEach(rows) { row in
                switch row {
                case .default:
                    TemplateCard(
                        name: ZipLiteral.ChecklistTemplate.defaultTemplateName,
                        questionCount: defaultQuestionCount,
                        isCurrent: currentTemplateID == nil
                    ) {
                        select(nil)
                    }
                case .custom(let template):
                    TemplateCard(
                        name: template.name,
                        questionCount: template.questionCodes.count,
                        isCurrent: currentTemplateID == template.id
                    ) {
                        select(template)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    func TemplateCard(
        name: String,
        questionCount: Int,
        isCurrent: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .title2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(minHeight: 48, alignment: .top)
                    Text("\(questionCount)\(ZipLiteral.ChecklistTemplate.questionCountSuffix)")
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .caption1Regular)
                }
                Spacer(minLength: 0)
                if isCurrent {
                    Text(ZipLiteral.ChecklistTemplate.inUse)
                        .foregroundStyle(Color.Text.onColorPrimary)
                        .applyZZSFont(zzsFontSet: .caption1Regular)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.ChecklistTag.backgroundBadge)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.Button.secondaryYellow)
            }
        }
    }

    // MARK: - Action

    func select(_ template: ChecklistTemplateData?) {
        onSelect(template)
        dismiss()
    }
}
