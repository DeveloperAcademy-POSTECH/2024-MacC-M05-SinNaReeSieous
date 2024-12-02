//
//  DetailEssentialInfoView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/28/24.
//

import SwiftUI
import PhotosUI
import SwiftData
import MapKit

struct DetailEssentialInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Query var homes: [HomeData]
    @Binding var homeData: HomeData
    
    @State private var isGettingAddress: Bool = false
    @FocusState private var focusField: EssentialInfoField?
    
    @State private var showPhotoTypeSelectSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var useCamera: Bool = false
    
    @StateObject private var locationManager = LocationManager()
    @State private var showAddressEnterView: Bool = false
    
    @State private var moveToChecklistView: Bool = false
    @State private var selectedSpaceType: SpaceType = .kitchen
    @State private var firstShow: Bool = true
    
    @State private var returnToResultCardSheet = false
    @State private var returnToDetailEssentialInfoView = false
    
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
                        await moveToChecklistView()
                    }
                },
                text: "체크리스트 보기"
            )
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .navigationDestination(isPresented: $moveToChecklistView, destination: {
            DetailChecklistView(homeData: $homeData,
                                selectedSpaceType: $selectedSpaceType,
                                firstShow: $firstShow,
                                returnToDetailEssentialInfoView: $returnToDetailEssentialInfoView)
        })
        .background(Color.Background.primary)
        .dismissKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onChange(of: returnToDetailEssentialInfoView) {
            if returnToDetailEssentialInfoView {
                returnToResultCardSheet = true
            }
        }
        .onChange(of: returnToResultCardSheet, { oldValue, newValue in
            presentationMode.wrappedValue.dismiss()
        })
        .onDisappear {
            Task {
                await returnToResultCardSheet()
            }
        }
        .onChange(of: homeData.rentalFeeData[0].value) { oldValue, newValue in
            if homeData.rentalFeeData[0].value.count > 4 {
                homeData.rentalFeeData[0].value.removeLast()
            }
        }
    }
}

private extension DetailEssentialInfoView {
    
    // MARK: - View
    
    var NavigationTitle: some View {
        Text("기본정보예요")
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
                Text(basicHomeName)
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
                    Text(addressPlaceHolder)
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
    
    // MARK: - Computed Values
    
    var basicHomeName: String {
        if let index = homes.firstIndex(of: homeData) {
            return "\(index+1)번째 집"
        } else {
            return "\(homes.count+1)번째 집"
        }
    }
    
    var addressPlaceHolder: String {
        if isGettingAddress {
            return "주소를 가져오는중 ..."
        } else {
            return "주소를 입력해 주세요"
        }
    }
    
    // MARK: - Custom Method
    
    private func fetchCurrentLocation() async {
        do {
            isGettingAddress = true
            let coordinate = try await locationManager.fetchCurrentLocation()
            homeData.location = LocationData(coordinate: coordinate)
            if let address = await reverseGeocode(coordinate) {
                homeData.locationText = address
            } else {
                print("현재 위치를 가져올 수 없습니다.")
            }
            print("현재위치 좌표: \(coordinate.latitude), \(coordinate.longitude)")
        } catch {
            print("현재위치 가져오기 실패: \(error.localizedDescription)")
        }
    }
    
    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return placemarks.first.flatMap { formatAddress(from: $0) }
        } catch {
            print("역지오코딩 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func formatAddress(from placemark: CLPlacemark) -> String? {
        let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
        let locality = placemark.locality ?? "" // 시/군/구
        let thoroughfare = placemark.thoroughfare ?? "" // 도로명
        let subThoroughfare = placemark.subThoroughfare ?? "" // 도로번호
        let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            .trimmingCharacters(in: .whitespaces)
        return address.isEmpty ? nil : address
    }
    
    private func formatAddress(from placemark: MKPlacemark) -> String? {
        let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
        let locality = placemark.locality ?? "" // 시/군/구
        let thoroughfare = placemark.thoroughfare ?? "" // 도로명
        let subThoroughfare = placemark.subThoroughfare ?? "" // 도로번호
        let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
            .trimmingCharacters(in: .whitespaces)
        return address.isEmpty ? nil : address
    }
    
    private func searchFacilities() async {
        if let coordinates = homeData.location?.coordinate {
            do {
                let location = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                let results = try await FacilityManager.searchFacilities(at: location)
                
                print(results)
                homeData.facilitiesData = Facility.allCases.filter { facility in
                    results[facility.rawValue] == true
                }.map { facility in
                    FacilityData(rawValue: facility.rawValue)
                }
                print(homeData.facilities.map{$0.icon})
                print(location)
            } catch let networkError as NetworkError {
                networkError.logError()
            } catch {
                print("Unexpected error: \(error)")
            }
        } else {
            homeData.facilitiesData = []
        }
    }
    
    private func moveToChecklistView() async {
        await searchFacilities()
        if homeData.homeName.isEmpty {
            homeData.homeName = basicHomeName
        }
        moveToChecklistView = true
    }
    
    private func returnToResultCardSheet() async {
        await searchFacilities()
        if homeData.homeName.isEmpty {
            homeData.homeName = basicHomeName
        }
    }
}

//
//#Preview {
//    EssentialInfoView(homeCount: .constant(1), showHomeHuntSheet: .constant(true))
//}
