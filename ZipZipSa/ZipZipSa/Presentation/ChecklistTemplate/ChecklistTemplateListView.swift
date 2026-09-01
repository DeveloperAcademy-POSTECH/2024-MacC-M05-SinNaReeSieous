//
//  ChecklistTemplateListView.swift
//  ZipZipSa
//

import SwiftUI
import SwiftData

/// 체크리스트 관리 화면. 기본 체크리스트(가상 행)와 커스텀 템플릿 목록을 보여주고,
/// 탭하면 수정 플로우로, +만들기로 생성 플로우로 진입한다.
struct ChecklistTemplateListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    @State private var editorTarget: EditorTarget?

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
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                CreateButton
            }
        }
        .fullScreenCover(item: $editorTarget) { target in
            switch target {
            case .new:
                ChecklistTemplateCreateFlowView(onClose: { editorTarget = nil })
            case .edit(let template):
                NavigationStack {
                    ChecklistTemplateEditView(template: template)
                }
            }
        }
    }
}

private extension ChecklistTemplateListView {

    /// fullScreenCover(item:)용 편집 대상.
    /// 신규(.new)는 템플릿 선택 화면부터, 수정(.edit)은 편집 화면부터 시작한다.
    enum EditorTarget: Identifiable {
        case new
        case edit(ChecklistTemplateData)

        var id: UUID {
            switch self {
            case .new: return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
            case .edit(let template): return template.id
            }
        }
    }

    var user: User? { users.first }

    var defaultQuestionCount: Int {
        QuestionProvider.questions(selectedCategories: user?.favoriteCategories ?? []).count
    }

    // MARK: - View

    var BackButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .applyZZSFont(zzsFontSet: .iconTitle1)
                Text(ZipLiteral.ChecklistTemplate.back)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Button.tertiary)
        }
    }

    var CreateButton: some View {
        Button {
            editorTarget = .new
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .applyZZSFont(zzsFontSet: .iconTitle1)
                Text(ZipLiteral.ChecklistTemplate.create)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Button.tertiary)
        }
    }

    var Title: some View {
        Text(ZipLiteral.ChecklistTemplate.listTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }

    /// 대표 체크리스트는 항상 맨 위에 노출한다.
    var rows: [ChecklistTemplateRow] {
        ChecklistTemplateRow.ordered(
            templates: user?.templates ?? [],
            markedID: user?.activeTemplateID
        )
    }

    var TemplateCardList: some View {
        VStack(spacing: 10) {
            ForEach(rows) { row in
                switch row {
                case .default:
                    DefaultTemplateCard
                case .custom(let template):
                    TemplateCard(template: template)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    /// 기본 체크리스트는 저장된 템플릿이 아니라 동적 규칙이므로 가상 행으로 그린다.
    /// 수정/삭제는 불가능하고 대표 지정만 가능하다.
    var DefaultTemplateCard: some View {
        Button {
            setPrimary(nil)
        } label: {
            TemplateCardLabel(
                name: ZipLiteral.ChecklistTemplate.defaultTemplateName,
                questionCount: defaultQuestionCount,
                isPrimary: user?.activeTemplateID == nil
            )
        }
    }

    func TemplateCard(template: ChecklistTemplateData) -> some View {
        Button {
            editorTarget = .edit(template)
        } label: {
            TemplateCardLabel(
                name: template.name,
                questionCount: template.questionCodes.count,
                isPrimary: user?.activeTemplateID == template.id
            )
        }
        .contextMenu {
            Button {
                setPrimary(template)
            } label: {
                Label(ZipLiteral.ChecklistTemplate.setAsPrimary, systemImage: "checkmark.circle")
            }
            Button(role: .destructive) {
                delete(template)
            } label: {
                Label(ZipLiteral.ChecklistTemplate.delete, systemImage: "trash")
            }
        }
    }

    func TemplateCardLabel(name: String, questionCount: Int, isPrimary: Bool) -> some View {
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
            if isPrimary {
                PrimaryBadge
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.Button.secondaryYellow)
        }
    }

    var PrimaryBadge: some View {
        Text(ZipLiteral.ChecklistTemplate.primaryBadge)
            .foregroundStyle(Color.Text.onColorPrimary)
            .applyZZSFont(zzsFontSet: .caption1Regular)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.ChecklistTag.backgroundBadge)
            }
    }

    // MARK: - Action

    /// nil이면 기본 체크리스트를 대표로 지정한다.
    func setPrimary(_ template: ChecklistTemplateData?) {
        let user = UserService.fetchOrCreateUser(context: modelContext)
        user.activeTemplateID = template?.id
        try? modelContext.save()
        HapticManager.shared.impact(style: .light)
    }

    func delete(_ template: ChecklistTemplateData) {
        let user = UserService.fetchOrCreateUser(context: modelContext)
        if user.activeTemplateID == template.id {
            user.activeTemplateID = nil
        }
        user.templates.removeAll { $0.id == template.id }
        modelContext.delete(template)
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        ChecklistTemplateListView()
    }
}
