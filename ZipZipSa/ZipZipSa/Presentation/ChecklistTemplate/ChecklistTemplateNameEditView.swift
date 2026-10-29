//
//  ChecklistTemplateNameEditView.swift
//  ZipZipSa
//

import SwiftUI
import SwiftData

/// 커스텀 체크리스트 이름 입력 + 대표 지정 화면.
/// "완료하기"는 입력한 이름으로, "나중에 할래요"는 기존/자동 이름으로 저장한다.
/// 저장 후 onComplete로 생성/수정 플로우(fullScreenCover) 전체를 닫는다.
struct ChecklistTemplateNameEditView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var viewModel: ChecklistTemplateEditViewModel
    /// 저장 완료 시 호출 — 편집 플로우 루트가 fullScreenCover를 닫는다.
    let onComplete: () -> Void

    /// "나중에 할래요"로 되돌릴 이름 (수정이면 기존 이름, 신규면 빈 값 → 자동 이름).
    @State private var originalName: String = ""

    var body: some View {
        ZStack {
            Color.Background.primary
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Title
                NameField
                PrimaryCheckbox
                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            BottomButtons
        }
        // 시스템 뒤로 버튼(ZZSNavigationBarAppearance)을 쓴다
        .navigationBarTitleDisplayMode(.inline)
        .dismissKeyboard()
        .onAppear {
            originalName = viewModel.isNew ? "" : viewModel.name
        }
    }
}

private extension ChecklistTemplateNameEditView {

    // MARK: - View

    var Title: some View {
        Text(viewModel.isNew ? ZipLiteral.ChecklistTemplate.nameNewTitle
                             : ZipLiteral.ChecklistTemplate.nameEditTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }

    var NameField: some View {
        HStack(spacing: 8) {
            TextField(
                ZipLiteral.ChecklistTemplate.namePlaceholder,
                text: $viewModel.name
            )
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .tint(Color.Text.placeholder)
            .onChange(of: viewModel.name) { _, newValue in
                if newValue.count > ChecklistTemplateEditViewModel.maxNameLength {
                    viewModel.name = String(newValue.prefix(ChecklistTemplateEditViewModel.maxNameLength))
                }
            }

            Text("(\(String(format: "%02d", viewModel.name.count))/\(ChecklistTemplateEditViewModel.maxNameLength))")
                .foregroundStyle(Color.Text.placeholder)
                .font(.system(size: 12))
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Button.enable)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    var PrimaryCheckbox: some View {
        Button {
            viewModel.isPrimary.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isPrimary ? "checkmark.square.fill" : "square")
                    .foregroundStyle(Color.Button.tertiary)
                    .applyZZSFont(zzsFontSet: .iconBody)
                Text(ZipLiteral.ChecklistTemplate.setPrimaryCheckbox)
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .subheadlineRegular)
            }
        }
        // 대표는 해제할 수 없다. 다른 체크리스트를 대표로 지정하면 바뀐다.
        .disabled(viewModel.wasPrimary)
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }

    var BottomButtons: some View {
        VStack(spacing: 16) {
            ZZSMainButton(
                action: { saveAndClose() },
                text: ZipLiteral.ChecklistTemplate.complete
            )
            Button {
                viewModel.name = originalName
                saveAndClose()
            } label: {
                Text(ZipLiteral.ChecklistTemplate.later)
                    .foregroundStyle(Color.Text.tertiary)
                    .applyZZSFont(zzsFontSet: .bodyBold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Action

    func saveAndClose() {
        viewModel.save(context: modelContext)
        onComplete()
    }
}
