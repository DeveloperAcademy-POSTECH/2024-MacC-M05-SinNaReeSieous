//
//  EssentialInfoView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import SwiftUI
import PhotosUI

struct EssentialInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showHomeHuntSheet: Bool
    
    @State private var homeName: String = ""
    @State private var address: String = ""
    @State private var imageExist: Bool = false
    @State private var selectedHomeCategory: HomeCategory? = nil
    @State private var selectedHomeRentalType: HomeRentalType? = nil
    @FocusState private var focusField: EssentialInfoField?
    @State private var homeAreaPyeong: String = ""
    @State private var homeAreaSquareMeter: String = ""
    @State private var selectedHomeDirection: HomeDirection? = nil
    @State private var rentalFee: [String] = ["", "", "", ""]
    
    @State private var showPhotoTypeSelectSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var useCamera: Bool = false
    @State private var selectedImageData: Data? = nil
    
    @StateObject private var locationManager = LocationManager()
    @State private var selectedCoordinates: CLLocationCoordinate2D?
    @State private var selectedLocationText: String? = nil
    @State private var showAddressEnterView: Bool = false
    
    @State private var moveToChecklistView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    NavigationTitle
                    NameSection
                    AddressSection
                    HomePhotoSection
                    HomeCategorySection
                    HomeRentalTypeSection
                    if selectedHomeRentalType != nil {
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
                        moveToChecklistView = true
                    },
                    text: "다음"
                )
                .padding([.horizontal, .top], 16)
                .padding(.bottom, 12)
                .background(Color.Background.primary)
            }
            .navigationDestination(isPresented: $moveToChecklistView, destination: {
                ChecklistView()
            })
            .background(Color.Background.primary)
            .dismissKeyboard()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton
                }
            }
        }
    }
}

private extension EssentialInfoView {
    
    // MARK: - View
    
    var NavigationTitle: some View {
        Text("기본정보를 알려주세요")
            .foregroundStyle(Color.Text.primary)
            .applyZZSFont(zzsFontSet: .largeTitle)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
    }
    
    // NameSection
    
    var NameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(text: "집 별명")
            TextField(text: $homeName) {
                Text(basicHouseName)
                    .foregroundStyle(Color.Text.placeholder)
                    .applyZZSFont(zzsFontSet: .bodyRegular)
            }
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
            AddressEnterView(resultCoordinates: $selectedCoordinates,
                             resultLocationText: $selectedLocationText)
                .presentationDragIndicator(.visible)
        }
    }
    
    var SearchAddressButton: some View {
        Button {
            showAddressEnterView = true
        } label: {
            HStack {
                if let selectedLocationText {
                    Text(selectedLocationText)
                        .foregroundStyle(Color.Text.primary)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                } else {
                    Text("주소를 입력해 주세요")
                        .foregroundStyle(Color.Text.placeholder)
                        .applyZZSFont(zzsFontSet: .bodyRegular)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
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
            print("get Current Address")
            Task {
                await fetchCurrentLocation()
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
            ImagePicker(imageData: $selectedImageData, useCamera: $useCamera)
                .ignoresSafeArea()
        }
    }
    
    var GetPhotoButton: some View {
        Button {
            showPhotoTypeSelectSheet = true
        } label: {
            if let selectedImageData {
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
                    selectedHomeCategory = selectedHomeCategory == category ? nil : category
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(selectedHomeCategory == category ? Color.Button.secondaryYellow : Color.Button.enable)
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
                    selectedHomeRentalType = selectedHomeRentalType == rentalType ? nil : rentalType
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(selectedHomeRentalType == rentalType ? Color.Button.secondaryYellow : Color.Button.enable)
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
            if let selectedHomeRentalType {
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
                    TextField(text: $rentalFee[moneyType.index[1]]) {
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
                TextField(text: $rentalFee[moneyType.index[0]]) {
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
                    TextField(text: $rentalFee[moneyType.index[0]]) {
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
            TextField(text: $homeAreaPyeong) {
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
        .onChange(of: homeAreaPyeong) { oldValue, newValue in
            guard focusField == .areaPyeong else {
                return
            }
            
            if homeAreaPyeong.isEmpty {
                homeAreaSquareMeter = ""
            } else {
                let pyeong = Float(homeAreaPyeong) ?? 0.0
                let squareMeter = pyeong * 3.306
                let formattedValue = String(format: "%.2f", squareMeter)
                homeAreaSquareMeter = formattedValue
            }
        }
    }
    
    var SquareMeterTextField: some View {
        HStack {
            TextField(text: $homeAreaSquareMeter) {
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
        .onChange(of: homeAreaSquareMeter) { oldValue, newValue in
            guard focusField == .areaSquareMeter else {
                return
            }
            
            if homeAreaSquareMeter.isEmpty {
                homeAreaPyeong = ""
            } else {
                let squareMeter = Float(homeAreaSquareMeter) ?? 0.0
                let pyeong = squareMeter / 3.306
                let formattedValue = String(format: "%.2f", pyeong)
                homeAreaPyeong = formattedValue
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
                    selectedHomeDirection = selectedHomeDirection == direction ? nil : direction
                } label: {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 16,
                                                                             bottomTrailing: 16,
                                                                             topTrailing: 16))
                    .fill(selectedHomeDirection == direction ? Color.Button.secondaryYellow : Color.Button.enable)
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
            showHomeHuntSheet = false
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.Icon.tertiary)
                .applyZZSFont(zzsFontSet: .bodyBold)
        }
    }
    
    // MARK: - Computed Values
    
    var basicHouseName: String {
        "1번째 집"
    }
    
    // MARK: - Custom Method
    
    private func fetchCurrentLocation() async {
        locationManager.requestLocationAuthorization()
        if let location = locationManager.userLocation {
            selectedCoordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            await reverseGeocode()
        } else {
            print("현재 위치를 가져올 수 없습니다.")
        }
    }
    
    private func reverseGeocode() async {
        guard let coordinates = selectedCoordinates else {
            print("좌표가 선택되지 않았습니다.")
            return
        }
        
        do {
            let address = try await AddressSearchManager.shared.getAddressForLatLng(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
            
            selectedLocationText = address
        } catch {
            print("주소 변환 실패: \(error.localizedDescription)")
            print("Error occurred: \(error)")
        }
    }
}

enum EssentialInfoField {
    case homeName
    case areaPyeong
    case areaSquareMeter
}


#Preview {
    EssentialInfoView(showHomeHuntSheet: .constant(true))
}
