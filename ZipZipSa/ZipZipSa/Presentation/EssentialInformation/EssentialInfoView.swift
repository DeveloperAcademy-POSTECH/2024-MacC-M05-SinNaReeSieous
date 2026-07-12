//
//  EssentialInfoView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import SwiftUI
import PhotosUI
import SwiftData
import MapKit

/// 기본정보 화면. 첫 기록(.homeHunt)과 재열람/수정(.review)을 모드로 처리한다.
/// homeHunt 진입(NavigationStack·HomeData 소유)은 HomeHuntSheetView가 담당한다.
struct EssentialInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Query var homes: [HomeData]

    let mode: EssentialInfoViewModel.Mode
    @Binding var homeData: HomeData

    /// homeHunt 전용 — 닫기 버튼과 하위 화면의 시트 닫기용으로 전달
    var showHomeHuntSheet: Binding<Bool>? = nil

    @State private var viewModel: EssentialInfoViewModel

    @State private var firstShow: Bool = true
    @FocusState private var focusField: EssentialInfoField?

    @State private var showPhotoTypeSelectSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var useCamera: Bool = false

    @State private var showAddressEnterView: Bool = false

    @State private var moveToChecklistView: Bool = false
    @State private var selectedSpaceType: SpaceType = .kitchen

    /// review 전용 — 체크리스트 저장 후 결과 카드 시트로 복귀하는 신호
    @State private var returnToResultCardSheet = false
    @State private var returnToDetailEssentialInfoView = false

    init(
        mode: EssentialInfoViewModel.Mode,
        homeData: Binding<HomeData>,
        showHomeHuntSheet: Binding<Bool>? = nil
    ) {
        self.mode = mode
        self._homeData = homeData
        self.showHomeHuntSheet = showHomeHuntSheet
        self._viewModel = State(initialValue: EssentialInfoViewModel(mode: mode))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationTitle
                NameSection
                AddressSection
                HomePhotoSection
                HomeCategorySection
                HomeRentalTypeSection
                if homeData.homeRentalType != nil {
                    HomeRentalMoneySection
                }
                HomeAreaSection
                HomeDirectionSection
            }
        }
        .scrollIndicators(.never)
        .contentMargins(.bottom, 120, for: .scrollContent)
        .clipped()
        .overlay(alignment: .bottom) {
            ZZSMainButton(
                action: {
                    Task {
                        await moveNextStep()
                    }
                },
                text: viewModel.bottomButtonText
            )
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .navigationDestination(isPresented: $moveToChecklistView) {
            ChecklistDestination
        }
        .background(Color.Background.primary)
        .dismissKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            if mode == .homeHunt {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton
                }
            }
        }
        .onAppear {
            guard mode == .homeHunt else { return }
            if firstShow {
                homeData = HomeData()
            }
            if homeData.homeName == viewModel.basicHomeName(homes: homes, homeData: homeData) {
                homeData.homeName = ""
            }
        }
        .onChange(of: returnToDetailEssentialInfoView) {
            if returnToDetailEssentialInfoView {
                returnToResultCardSheet = true
            }
        }
        .onChange(of: returnToResultCardSheet, { oldValue, newValue in
            presentationMode.wrappedValue.dismiss()
        })
        .onDisappear {
            guard mode == .review else { return }
            Task {
                await viewModel.completeEditing(homeData: homeData, homes: homes)
            }
        }
    }
}

private extension EssentialInfoView {

    // MARK: - View

    @ViewBuilder
    var ChecklistDestination: some View {
        switch mode {
        case .homeHunt:
            ChecklistView(
                mode: .homeHunt,
                homeData: $homeData,
                selectedSpaceType: $selectedSpaceType,
                firstShow: $firstShow,
                showHomeHuntSheet: showHomeHuntSheet)
        case .review:
            ChecklistView(
                mode: .review,
                homeData: $homeData,
                selectedSpaceType: $selectedSpaceType,
                firstShow: $firstShow,
                onSaveComplete: { returnToDetailEssentialInfoView = true })
        }
    }

    var NavigationTitle: some View {
        Text(viewModel.navigationTitle)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
    }

    // NameSection

    var NameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "집 별명")
            TextField(text: $homeData.homeName) {
                Text(viewModel.basicHomeName(homes: homes, homeData: homeData))
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
        }
        .onChange(of: homeData.homeName) { oldValue, newValue in
            if homeData.homeName.count > 20 {
                homeData.homeName.removeLast()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    // AddressSection

    var AddressSection: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                SectionTitle(text: "주소")
                Spacer()
            }
            .padding(.bottom, 8)
            SearchAddressButton
            GetCurrentAddressButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .sheet(isPresented: $showAddressEnterView) {
            AddressEnterView(resultCoordinates: $homeData.location,
                             resultLocationText: $homeData.locationText)
            .presentationDragIndicator(.visible)
        }
    }

    var SearchAddressButton: some View {
        Button {
            showAddressEnterView = true
        } label: {
            HStack {
                if let selectedLocationText = homeData.locationText {
                    Text(selectedLocationText)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                } else {
                    Text(viewModel.addressPlaceHolder)
                        .foregroundStyle(Color.Text.placeholder)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
        }
    }

    var GetCurrentAddressButton: some View {
        Button {
            Task {
                await viewModel.fetchCurrentLocation(for: homeData)
            }
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.Icon.tertiary)
                    .applyZZSFont(zzsFontSet: .iconSubheadline)
                    .padding(.horizontal, 2)
                Text("현재위치로 저장하기")
                    .foregroundStyle(Color.Icon.tertiary)
                    .applyZZSFont(zzsFontSet: .caption1Regular)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.Icon.tertiary)
                            .frame(height: 0.6)
                    }
            }
            .padding(8)
            .padding(.horizontal, 8)
        }
    }

    // HomePhotoSection

    var HomePhotoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "건물 외관")
            GetPhotoButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .confirmationDialog("타이틀", isPresented: $showPhotoTypeSelectSheet) {
            Button("카메라") {
                useCamera = true
                showImagePicker = true
            }
            Button("사진 보관함") {
                useCamera = false
                showImagePicker = true
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(imageData: $homeData.imageData, useCamera: $useCamera)
                .ignoresSafeArea()
        }
    }

    var GetPhotoButton: some View {
        Button {
            showPhotoTypeSelectSheet = true
        } label: {
            if let selectedImageData = homeData.imageData {
                Image(uiImage: UIImage(data: selectedImageData)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.screenSize.width-32, height: (UIScreen.screenSize.width-32)/343*144)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                                        bottomTrailing: 16,
                                                                                        topTrailing: 16)))
            } else {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
                .frame(width: UIScreen.screenSize.width-32, height: (UIScreen.screenSize.width-32)/343*144)
                .overlay {
                    Image(systemName: "photo.badge.plus.fill")
                        .foregroundStyle(Color.Icon.secondary)
                        .applyZZSFont(zzsFontSet: .iconTitle1)
                }
            }
        }
    }

    // HomeCategorySection

    var HomeCategorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "유형")
            HomeCategoryButtonStack
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    var HomeCategoryButtonStack: some View {
        HStack(spacing: 8) {
            ForEach(HomeCategory.allCases.indices, id: \.self) { index in
                let category = HomeCategory.allCases[index]
                Button {
                    homeData.homeCategoryData = homeData.homeCategoryType == category ? nil : category.rawValue
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(homeData.homeCategoryType == category ? Color.Button.secondaryYellow : Color.Button.enable)
                    .frame(height: 40)
                    .overlay {
                        Text(category.text)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                }
            }
        }
    }

    // HomeRentalTypeSection

    var HomeRentalTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "계약형태")
            HomeRentalTypeButtonStack
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    var HomeRentalTypeButtonStack: some View {
        HStack(spacing: 8) {
            ForEach(HomeRentalType.allCases.indices, id: \.self) { index in
                let rentalType = HomeRentalType.allCases[index]
                Button {
                    homeData.homeRentalTypeData = homeData.homeRentalType == rentalType ? nil : rentalType.rawValue
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(homeData.homeRentalType == rentalType ? Color.Button.secondaryYellow : Color.Button.enable)
                    .frame(height: 40)
                    .overlay {
                        Text(rentalType.text)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                }
            }
        }
    }

    // HomeRentalMoneySection

    var HomeRentalMoneySection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let selectedHomeRentalType = homeData.homeRentalType {
                ForEach(selectedHomeRentalType.moneyTypes.indices, id: \.self) { index in
                    let moneyType = selectedHomeRentalType.moneyTypes[index]
                    HomeRentalMoneyTextFieldSection(moneyType: moneyType)
                }
            }
        }
        .padding(16)
        .background(Color.Background.secondary)
        .padding(.bottom, 24)
    }

    func HomeRentalMoneyTextFieldSection(moneyType: HomeRentalMoneytype) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: moneyType.text)
            HomeRentalMoneyTextField(moneyType: moneyType)
        }
    }

    func HomeRentalMoneyTextField(moneyType: HomeRentalMoneytype) -> some View  {
        HStack(spacing: 16) {
            if moneyType == .deposit {
                HStack(spacing: 6) {
                    TextField(text: $homeData.rentalFeeData.sorted { $0.wrappedValue.index < $1.wrappedValue.index }[moneyType.index[1]].value) {
                        Text("000")
                            .foregroundStyle(Color.Text.placeholder)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                                 bottomTrailing: 16,
                                                                                 topTrailing: 16))
                        .fill(Color.Button.enable)
                    }
                    Text("억")
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
            }

            HStack(spacing: 6) {
                TextField(text: $homeData.rentalFeeData.sorted { $0.wrappedValue.index < $1.wrappedValue.index }[moneyType.index[0]].value) {
                    Text("000")
                        .foregroundStyle(Color.Text.placeholder)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(Color.Button.enable)
                }
                Text("만원")
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }

            if moneyType != .deposit {
                HStack(spacing: 6) {
                    TextField(text: $homeData.rentalFeeData.sorted { $0.wrappedValue.index < $1.wrappedValue.index }[moneyType.index[0]].value) {
                        Text("000")
                            .foregroundStyle(Color.Text.placeholder)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                                 bottomTrailing: 16,
                                                                                 topTrailing: 16))
                        .fill(Color.Button.enable)
                    }
                    Text("억")
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
                .hidden()
            }
        }
        .onChange(of: homeData.rentalFeeData[0].value) { oldValue, newValue in
            if homeData.rentalFeeData[0].value.count > 4 {
                homeData.rentalFeeData[0].value.removeLast()
            }
        }
        .onChange(of: homeData.rentalFeeData[1].value) { oldValue, newValue in
            if homeData.rentalFeeData[1].value.count > 4 {
                homeData.rentalFeeData[1].value.removeLast()
            }
        }
        .onChange(of: homeData.rentalFeeData[2].value) { oldValue, newValue in
            if homeData.rentalFeeData[2].value.count > 4 {
                homeData.rentalFeeData[2].value.removeLast()
            }
        }
        .onChange(of: homeData.rentalFeeData[3].value) { oldValue, newValue in
            if homeData.rentalFeeData[3].value.count > 4 {
                homeData.rentalFeeData[3].value.removeLast()
            }
        }
    }

    // HomeArea

    var HomeAreaSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "면적")
            HomeAreaTextFieldStack
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    var HomeAreaTextFieldStack: some View {
        HStack(spacing: 8) {
            PyeongTextField
            Image(systemName: "arrow.left.arrow.right")
                .foregroundStyle(Color.Icon.tertiary)
                .applyZZSFont(zzsFontSet: .iconBody)
            SquareMeterTextField
        }
    }

    var PyeongTextField: some View {
        HStack(spacing: 6) {
            TextField(text: $homeData.homeAreaPyeong) {
                Text("000")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .keyboardType(.decimalPad)
            .focused($focusField, equals: .areaPyeong)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
            Text("평")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
        }
        .onChange(of: homeData.homeAreaPyeong) { oldValue, newValue in
            guard focusField == .areaPyeong else {
                return
            }

            if homeData.homeAreaPyeong.isEmpty {
                homeData.homeAreaSquareMeter = ""
            } else {
                let pyeong = Float(homeData.homeAreaPyeong) ?? 0.0
                let squareMeter = pyeong * 3.306
                let formattedValue = String(format: "%.2f", squareMeter)
                homeData.homeAreaSquareMeter = formattedValue
            }
        }
    }

    var SquareMeterTextField: some View {
        HStack {
            TextField(text: $homeData.homeAreaSquareMeter) {
                Text("000")
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
            .keyboardType(.decimalPad)
            .focused($focusField, equals: .areaSquareMeter)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyRegular)
            .padding(.horizontal, 20)
            .frame(height: 40)
            .background {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                         bottomTrailing: 16,
                                                                         topTrailing: 16))
                .fill(Color.Button.enable)
            }
            Text("㎡")
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyRegular)
        }
        .onChange(of: homeData.homeAreaSquareMeter) { oldValue, newValue in
            guard focusField == .areaSquareMeter else {
                return
            }

            if homeData.homeAreaSquareMeter.isEmpty {
                homeData.homeAreaPyeong = ""
            } else {
                let squareMeter = Float( homeData.homeAreaSquareMeter) ?? 0.0
                let pyeong = squareMeter / 3.306
                let formattedValue = String(format: "%.2f", pyeong)
                homeData.homeAreaPyeong = formattedValue
            }
        }
    }

    // HomeDirection

    var HomeDirectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "집의 방향")
            HomeDirectionButtonStack
        }
        .padding(.horizontal, 16)
    }

    var HomeDirectionButtonStack: some View {
        HStack(spacing: 8) {
            ForEach(HomeDirection.allCases.indices, id: \.self) { index in
                let direction = HomeDirection.allCases[index]
                Button {
                    homeData.homeDirectionData = homeData.homeDirectionType == direction ? nil : direction.rawValue
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(homeData.homeDirectionType == direction ? Color.Button.secondaryYellow : Color.Button.enable)
                    .frame(height: 40)
                    .overlay {
                        Text(direction.text)
                            .foregroundStyle(Color.Text.primary)
                            .applyZZSFont(zzsFontSet: .bodyRegular)
                    }
                }
            }
        }
    }

    func SectionTitle(text: String) -> some View {
        Text(text)
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .bodyBold)
    }

    var CloseButton: some View {
        Button {
            showHomeHuntSheet?.wrappedValue = false
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.Icon.tertiary)
                .applyZZSFont(zzsFontSet: .bodyBold)
        }
    }

    // MARK: - Action

    func moveNextStep() async {
        await viewModel.completeEditing(homeData: homeData, homes: homes)
        moveToChecklistView = true
    }
}

enum EssentialInfoField {
    case homeName
    case areaPyeong
    case areaSquareMeter
}
