//
//  ChecklistTemplateListView.swift
//  ZipZipSa
//

import SwiftUI
import SwiftData

/// 체크리스트 관리 화면. 기본 체크리스트를 포함한 템플릿 목록을 보여주고,
/// 탭하면 수정 플로우로, +만들기로 생성 플로우로 진입한다.
struct ChecklistTemplateListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    @State private var editorTarget: EditorTarget?
    /// 삭제 확인 대상. nil이면 알럿을 띄우지 않는다.
    @State private var templateToDelete: ChecklistTemplateData?
    /// 대표 체크리스트를 지우려 했을 때의 안내. 대표의 이름을 담는다. nil이면 알럿을 띄우지 않는다.
    @State private var primaryNameToBlockDelete: String?

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
        // 시스템 뒤로 버튼(ZZSNavigationBarAppearance)을 쓴다
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CreateButton
            }
        }
        .alert(
            ZipLiteral.Alert.deleteTemplateTitle(templateToDelete?.name ?? ""),
            isPresented: Binding(
                get: { templateToDelete != nil },
                set: { if !$0 { templateToDelete = nil } }
            )
        ) {
            // 알럿을 만들 때의 대상을 클로저가 붙잡아두므로 닫히는 순서와 무관하게 안전하다
            if let template = templateToDelete {
                Button(ZipLiteral.Alert.delete, role: .destructive) {
                    delete(template)
                }
            }
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
        } message: {
            Text(ZipLiteral.Alert.deleteTemplateMessage)
                .multilineTextAlignment(.center)
        }
        .alert(
            ZipLiteral.Alert.cannotDeletePrimaryTitle(primaryNameToBlockDelete ?? ""),
            isPresented: Binding(
                get: { primaryNameToBlockDelete != nil },
                set: { if !$0 { primaryNameToBlockDelete = nil } }
            )
        ) {
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
        } message: {
            Text(ZipLiteral.Alert.cannotDeletePrimaryMessage)
                .multilineTextAlignment(.center)
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

    // MARK: - View

    /// iOS 26은 +만(유리), iOS 18은 "+ 만들기".
    var CreateButton: some View {
        ZZSToolbarButton(title: ZipLiteral.ChecklistTemplate.create, systemImage: "plus") {
            editorTarget = .new
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
    var rows: [ChecklistTemplateData] {
        ChecklistTemplateRow.ordered(
            templates: user?.templates ?? [],
            markedID: user?.activeTemplateID
        )
    }

    var TemplateCardList: some View {
        VStack(spacing: 10) {
            ForEach(rows) { template in
                TemplateCard(template: template)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
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
                // 대표는 먼저 다른 체크리스트를 대표로 지정해야 지울 수 있다
                if user?.activeTemplateID == template.id {
                    primaryNameToBlockDelete = template.name
                } else {
                    templateToDelete = template
                }
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

    func setPrimary(_ template: ChecklistTemplateData) {
        let user = UserService.fetchOrCreateUser(context: modelContext)
        user.activeTemplateID = template.id
        try? modelContext.save()
        HapticManager.shared.impact(style: .light)
    }

    func delete(_ template: ChecklistTemplateData) {
        let user = UserService.fetchOrCreateUser(context: modelContext)
        // 대표는 삭제 메뉴에서 미리 막는다
        guard user.activeTemplateID != template.id else { return }
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
