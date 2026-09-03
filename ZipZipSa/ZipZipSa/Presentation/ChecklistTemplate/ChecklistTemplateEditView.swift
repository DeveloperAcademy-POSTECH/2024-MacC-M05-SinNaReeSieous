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
    /// 저장하지 않고 나가려 할 때 확인
    @State private var showDiscardAlert = false

    /// 관심 카테고리 선택이 사라지면서 카테고리·추가 칩을 노출하지 않는다.
    /// 체크리스트 작성 화면(ChecklistRowView)과 같은 방식으로, 계산 로직은 그대로 두고 렌더링만 끈다.
    private let showsCategoryChips = false

    /// 템플릿 선택 화면에서 푸시된 경우 전체 플로우(fullScreenCover)를 닫는 클로저.
    /// nil이면 이 화면이 플로우 루트이므로 dismiss로 닫는다.
    private let onClose: (() -> Void)?

    init(
        template: ChecklistTemplateData?,
        initialCodes: [String]? = nil,
        onClose: (() -> Void)? = nil
    ) {
        self._viewModel = State(initialValue: ChecklistTemplateEditViewModel(
            template: template,
            initialCodes: initialCodes
        ))
        self.onClose = onClose
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
        .alert(ZipLiteral.Alert.discardTemplateEditTitle, isPresented: $showDiscardAlert) {
            Button(ZipLiteral.Alert.leave, role: .destructive) {
                closeFlow()
            }
            Button(ZipLiteral.Alert.cancel, role: .cancel) { }
        } message: {
            Text(ZipLiteral.Alert.discardTemplateEditMessage)
                .multilineTextAlignment(.center)
        }
        .navigationDestination(isPresented: $moveToNameEdit) {
            ChecklistTemplateNameEditView(viewModel: viewModel) {
                closeFlow()
            }
        }
    }
}

private extension ChecklistTemplateEditView {

    var includedItems: [ChecklistItem] {
        viewModel.includedItems(for: selectedSpaceType)
    }

    // MARK: - View

    var availableItems: [ChecklistItem] {
        viewModel.availableItems(for: selectedSpaceType)
    }

    /// 질문 사이 구분선 (Figma 6335-22914: 위아래 24).
    /// 좌우 여백은 쓰는 쪽에서 준다 — 질문 추가하기 섹션은 이미 안쪽으로 들어와 있다.
    var QuestionDivider: some View {
        ZZSSperator(color: Color.Additional.checklistSeperator)
            .padding(.vertical, 24)
    }

    func closeFlow() {
        if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }

    var CloseButton: some View {
        Button {
            showDiscardAlert = true
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
        // 공간 탭을 바꾸면 고정 헤더 위치로 되돌린다(집 보러가기 체크리스트와 동일).
        // 최소 스크롤이라 헤더가 이미 보이면 그대로 두고, 타이틀이 보이던 상태면 유지된다.
        ScrollViewReader { scrollView in
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    Spacer().frame(height: 18)
                    ForEach(includedItems) { item in
                        TemplateQuestionCell(item: item, isIncluded: true)
                            .padding(.horizontal, 16)
                        if item.id == includedItems.last?.id {
                            Spacer().frame(height: 40)
                        } else {
                            QuestionDivider
                                .padding(.horizontal, 16)
                        }
                    }
                    AddSection
                } header: {
                    ChecklistSpaceButtonStackView(selectedSpaceType: $selectedSpaceType)
                        .id(1)
                }
            }
            .onChange(of: selectedSpaceType) { oldValue, newValue in
                scrollView.scrollTo(1)
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
                VStack(spacing: 0) {
                    ForEach(availableItems) { item in
                        TemplateQuestionCell(item: item, isIncluded: false)
                        if item.id != availableItems.last?.id {
                            QuestionDivider
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Background.disabled)
    }

    /// 질문 셀: 액션(삭제하기/추가하기) + 질문 + 부연 + 비활성 답변 미리보기.
    func TemplateQuestionCell(item: ChecklistItem, isIncluded: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                if showsCategoryChips {
                    ChipStack(item: item)
                }
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
            ForEach(item.displayCategories, id: \.self) { category in
                Chip(text: category.text, color: Color.ChecklistTag.backgroundYellow)
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
