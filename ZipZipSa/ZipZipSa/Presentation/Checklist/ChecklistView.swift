//
//  ChecklistView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import RoomPlan
import SwiftData

/// 체크리스트 화면. 첫 기록(.homeHunt)과 재열람/수정(.review)을 모드로 처리한다.
struct ChecklistView: View {
    @Environment(\.dismiss) private var dismiss
    @Query var users: [User]

    let mode: ChecklistViewModel.Mode
    @Binding var homeData: HomeData
    @Binding var selectedSpaceType: SpaceType
    @Binding var firstShow: Bool

    /// homeHunt 전용 — 스캔 완료 후 시트 닫기용으로 하위 화면에 전달
    var showHomeHuntSheet: Binding<Bool>? = nil
    /// review 전용 — 저장 버튼으로 화면을 나갈 때 호출
    var onSaveComplete: (() -> Void)? = nil

    @State private var viewModel: ChecklistViewModel

    @State private var model: UIImage? = nil
    @State private var moveToRoomScanInfoView: Bool = false
    @State private var moveToUnsupportedDeviceView: Bool = false
    @State private var showTemplateSwitchSheet: Bool = false

    init(
        mode: ChecklistViewModel.Mode,
        homeData: Binding<HomeData>,
        selectedSpaceType: Binding<SpaceType>,
        firstShow: Binding<Bool>,
        showHomeHuntSheet: Binding<Bool>? = nil,
        onSaveComplete: (() -> Void)? = nil
    ) {
        self.mode = mode
        self._homeData = homeData
        self._selectedSpaceType = selectedSpaceType
        self._firstShow = firstShow
        self.showHomeHuntSheet = showHomeHuntSheet
        self.onSaveComplete = onSaveComplete
        self._viewModel = State(initialValue: ChecklistViewModel(mode: mode))
    }

    var body: some View {
        VStack(spacing: 0) {
            ZZSCollapsingTitleScrollView(tab: selectedSpaceType) {
                NavigationBarTitle
            } header: {
                ChecklistSpaceButtonStackView(selectedSpaceType: $selectedSpaceType)
            } content: {
                ChecklistList
            }
        }
        // iOS 26은 "체크리스트 변경"이 아이콘만 보이므로 처음 한 번 무슨 버튼인지 알려준다
        // 꼬리가 툴바의 유리 버튼(가운데 x: 화면 오른쪽 끝에서 38)을 가리키도록 버튼 바로 아래에 붙인다
        .zzsOneTimeTipTopTrailing(
            key: ZipLiteral.OneTimeTip.checklistSwitchKey,
            text: ZipLiteral.OneTimeTip.checklistSwitch,
            isEnabled: showsChecklistSwitchTip,
            top: -6,
            trailing: 16,
            arrowInsetFromTrailing: 22
        )
        .overlay(alignment: .bottom) {
            ZZSMainButton(
                action: {
                    moveNextStep()
                },
                text: viewModel.bottomButtonText(for: selectedSpaceType)
            )
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .onAppear {
            if firstShow {
                selectedSpaceType = .livingRoom
                firstShow = false
            }
            viewModel.start(
                homeData: homeData,
                userFavorites: users.first?.favoriteCategories ?? [],
                activeTemplate: users.first?.activeTemplate
            )
        }
        .onDisappear {
            viewModel.save(to: homeData)
            if mode == .review {
                viewModel.applyResult(to: homeData)
            }
        }
        .background(Color.Background.primary)
        .dismissKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if mode == .homeHunt {
                ToolbarItem(placement: .topBarTrailing) {
                    // iOS 26은 아이콘만(유리), iOS 18은 "아이콘 + 체크리스트 변경"
                    ZZSToolbarButton(
                        title: ZipLiteral.ChecklistTemplate.switchButton,
                        systemImage: "pencil.and.list.clipboard",
                        iconFont: .iconBody
                    ) {
                        showTemplateSwitchSheet = true
                    }
                }
            }
        }
        .sheet(isPresented: $showTemplateSwitchSheet) {
            ChecklistTemplateSwitchSheet(
                currentTemplateID: viewModel.template?.id
            ) { template in
                viewModel.switchTemplate(template, homeData: homeData)
            }
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $moveToRoomScanInfoView) {
            RoomScanInfoView(model: $model, homeData: $homeData, showHomeHuntSheet: showHomeHuntSheet ?? .constant(false))
        }
        .navigationDestination(isPresented: $moveToUnsupportedDeviceView) {
            UnsupportedDeviceView(model: $model, homeData: $homeData, showHomeHuntSheet: showHomeHuntSheet ?? .constant(false))
        }
    }
}

private extension ChecklistView {

    var showsChecklistSwitchTip: Bool {
        guard mode == .homeHunt else { return false }
        if #available(iOS 26, *) { return true }
        return false
    }

    var currentItems: [ChecklistItem] {
        viewModel.items(for: selectedSpaceType)
    }

    // MARK: - View

    /// 질문 사이 구분선 (Figma 5120-12035: 좌우 16, 위아래 24)
    var QuestionDivider: some View {
        ZZSSperator(color: Color.Additional.checklistSeperator)
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
    }

    var ChecklistList: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 18)
            ForEach(currentItems) { checklistItem in
                ChecklistRowView(
                    viewModel: viewModel,
                    checklistItem: checklistItem
                )
                .padding(.horizontal, 16)
                if checklistItem.id == currentItems.last?.id {
                    Spacer().frame(height: 40)
                } else {
                    QuestionDivider
                }
            }
            Memo
        }
    }

    var NavigationBarTitle: some View {
        HStack {
            Text(viewModel.navigationTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.horizontal, 16)
        // 상단 버튼과 타이틀 사이 간격은 전월세사기 도감과 같게(위 12) 맞춘다
        .padding(.top, 12)
    }

    var Memo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(ZipLiteral.Checklist.memoSectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .headline)
            TextEditor(text: $homeData.memoData.sorted { $0.wrappedValue.index < $1.wrappedValue.index }[selectedSpaceType.rawValue].value)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
                .tint(Color.Text.placeholder)
                .overlay(alignment: .topLeading) {
                    if homeData.memoData.sorted(by: { $0.index < $1.index })[selectedSpaceType.rawValue].value.isEmpty {
                        Text(ZipLiteral.Checklist.memoPlaceHolder)
                            .foregroundStyle(Color.Text.placeholder)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                            .offset(x: 6, y: 10)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .frame(height: 150)
                .background(Color.Button.enable)
                .clipShape (
                    RoundedRectangle(cornerRadius: 12)
                )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Action

    func moveNextStep() {
        guard viewModel.isLastSpace(selectedSpaceType) else {
            if let nextSpaceType = SpaceType(rawValue: selectedSpaceType.rawValue + 1) {
                selectedSpaceType = nextSpaceType
            }
            return
        }

        viewModel.applyResult(to: homeData)
        switch mode {
        case .homeHunt:
            if RoomCaptureSession.isSupported {
                moveToRoomScanInfoView = true
            } else {
                moveToUnsupportedDeviceView = true
            }
        case .review:
            onSaveComplete?()
            dismiss()
        }
    }
}
