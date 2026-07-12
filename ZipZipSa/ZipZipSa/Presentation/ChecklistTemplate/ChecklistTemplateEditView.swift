//
//  ChecklistTemplateEditView.swift
//  ZipZipSa
//

import SwiftUI
import SwiftData

/// 커스텀 체크리스트 질문 선택 화면.
/// 포함된 질문은 "삭제하기"로 빼고, 접이식 "질문 추가하기" 섹션에서 다시 넣는다.
/// fullScreenCover의 NavigationStack 루트로 띄워지며, "다음"으로 이름 입력 화면을 푸시한다.
struct ChecklistTemplateEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]

    @State private var viewModel: ChecklistTemplateEditViewModel
    @State private var selectedSpaceType: SpaceType = .livingRoom
    @State private var isAddSectionExpanded = false
    @State private var moveToNameEdit = false

    init(template: ChecklistTemplateData?) {
        self._viewModel = State(initialValue: ChecklistTemplateEditViewModel(template: template))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Title
                    QuestionList
                }
            }
            .clipped()
            .scrollIndicators(.never)
            .contentMargins(.bottom, 120, for: .scrollContent)
        }
        .overlay(alignment: .bottom) {
            ZZSMainButton(
                action: { moveToNameEdit = true },
                text: ZipLiteral.ChecklistTemplate.next
            )
            .disabled(!viewModel.isValid)
            .opacity(viewModel.isValid ? 1 : 0.5)
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .background(Color.Background.primary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CloseButton
            }
        }
        .onAppear {
            viewModel.start(user: users.first)
        }
        .navigationDestination(isPresented: $moveToNameEdit) {
            ChecklistTemplateNameEditView(viewModel: viewModel) {
                dismiss()
            }
        }
    }
}

private extension ChecklistTemplateEditView {

    // MARK: - View

    var CloseButton: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "xmark")
                    .applyZZSFont(zzsFontSet: .iconTitle1)
                Text(ZipLiteral.ChecklistTemplate.close)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Button.tertiary)
        }
    }

    var Title: some View {
        HStack {
            Text("\(viewModel.displayName)\n\(ZipLiteral.ChecklistTemplate.editTitleSuffix)")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    var QuestionList: some View {
        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            Section {
                Spacer().frame(height: 18)
                ForEach(viewModel.includedItems(for: selectedSpaceType)) { item in
                    TemplateQuestionCell(item: item, isIncluded: true)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                }
                AddSection
            } header: {
                ChecklistSpaceButtonStackView(selectedSpaceType: $selectedSpaceType)
            }
        }
    }

    /// 접이식 "질문 추가하기" 섹션. 선택되지 않은 질문을 회색 배경 위에 보여준다.
    var AddSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                withAnimation { isAddSectionExpanded.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Text(ZipLiteral.ChecklistTemplate.addSectionTitle)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyBold)
                    Image(systemName: isAddSectionExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .iconBody)
                }
            }

            if isAddSectionExpanded {
                VStack(spacing: 40) {
                    ForEach(viewModel.availableItems(for: selectedSpaceType)) { item in
                        TemplateQuestionCell(item: item, isIncluded: false)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Background.disabled)
    }

    /// 질문 셀: 카테고리 칩 + 액션(삭제하기/추가하기) + 질문 + 부연 + 비활성 답변 미리보기.
    func TemplateQuestionCell(item: ChecklistItem, isIncluded: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                ChipStack(item: item)
                Spacer()
                if isIncluded {
                    Button {
                        withAnimation { viewModel.remove(item) }
                    } label: {
                        Text(ZipLiteral.ChecklistTemplate.removeAction)
                            .foregroundStyle(Color.Text.error)
                            .applyZZSFont(zzsFontSet: .caption1Regular)
                    }
                } else {
                    Button {
                        withAnimation { viewModel.add(item) }
                    } label: {
                        Text(ZipLiteral.ChecklistTemplate.addAction)
                            .foregroundStyle(Color.Text.secondary)
                            .applyZZSFont(zzsFontSet: .subheadlineBold)
                    }
                }
            }

            Text(item.question.question)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .headline)

            if let remark = item.remark {
                HStack(alignment: .top, spacing: 8) {
                    Image(.charChecklistRemark)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 20)
                    Text(remark)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .caption1Regular)
                }
            }

            AnswerPreview(item: item)
                .padding(.top, 8)
        }
    }

    func ChipStack(item: ChecklistItem) -> some View {
        HStack(spacing: 8) {
            if item.checkListType == .advanced {
                Chip(text: item.checkListType.text, color: Color.ChecklistTag.backgroundGray)
            }
            if item.basicCategory.isSelectable {
                Chip(text: item.basicCategory.text, color: Color.ChecklistTag.backgroundYellow)
            }
        }
    }

    func Chip(text: String, color: Color) -> some View {
        Text(text)
            .foregroundStyle(Color.ChecklistTag.colorGray)
            .applyZZSFont(zzsFontSet: .footnote)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
            }
    }

    /// 답변 버튼의 비활성 미리보기. 편집 화면에서는 답변할 수 없다.
    func AnswerPreview(item: ChecklistItem) -> some View {
        let options = item.question.answerOptions
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 10),
            count: options.count > 3 ? 3 : options.count
        )
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(options.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Button.disabled)
                    .frame(height: 40)
                    .overlay {
                        Text(options[index])
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChecklistTemplateEditView(template: nil)
    }
}
