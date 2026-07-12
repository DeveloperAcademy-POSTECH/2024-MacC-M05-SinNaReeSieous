//
//  ZZSShareCard.swift
//  ZipZipSa
//
//  결과 카드의 단일 구현.
//  기존에 ShareCardView / ShareCardSheet / ShareCaptureCardView(+ 각 Header) 3벌로
//  복제되어 있던 것을 layout 모드 하나로 통합했다.
//

import SwiftUI

struct ZZSShareCard: View {

    /// 카드가 쓰이는 방식에 따른 렌더링 차이.
    enum Layout {
        /// 화면에 표시: 집 사진을 비동기 로드하고, 시설 아이콘 탭 시 말풍선을 띄운다.
        case interactive
        /// 이미지 캡처(공유/저장)용 오프스크린 렌더링: 사진을 즉시 그리고 인터랙션이 없다.
        /// 캡처는 스냅샷 시점의 프레임을 그대로 찍으므로 비동기 로드를 쓰면 사진이 빠진다.
        case capture
    }

    @Binding var homeData: HomeData
    let layout: Layout

    @State private var selectedFacility: String? = nil
    @State private var showBubble: Bool = false
    @State private var timer: Timer?

    let columnLayout = Array(repeating: GridItem(.flexible()), count: 3)

    var hazardTags: [String] {
        return homeData.hazards.map { $0.text }
    }

    var availableFacility: [Facility] {
        return homeData.facilities
    }

    var resultMaxScores: [String: Float] {
        homeData.loadDictionary(data: homeData.resultMaxScoreData,
                                type: [String: Float].self) ?? [:]
    }

    var resultScores: [String: Float] {
        homeData.loadDictionary(data: homeData.resultScoreData,
                                type: [String: Float].self) ?? [:]
    }

    let categoryOrders = ChecklistCategory.resultCardOrder.map(\.rawValue)

    var body: some View {
        VStack {
            ZZSShareCardHeader(homeData: $homeData, layout: layout)

            ChecklistResult
            ZZSSperator()

            CriticalTags
            ZZSSperator()

            RoomModel
            ZZSSperator()

            NearbyFacilities
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 1)
                .background(Color.Layer.first.clipShape(RoundedRectangle(cornerRadius: 16)))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 50)
    }
}

private extension ZZSShareCard {
    // MARK: - View

    var ChecklistResult: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.categorySectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)

            ForEach(categoryOrders.indices, id: \.self) { index in
                let categoryRawValue = categoryOrders[index]
                if let maxScore = resultMaxScores[categoryRawValue],
                   let score = resultScores[categoryRawValue],
                   let category = ChecklistCategory(rawValue: categoryRawValue) {
                    ScoreGraph(category: category.text, maxScore: maxScore, currentScore: score)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 4)
    }

    var CriticalTags: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.hazardSectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)

            if !hazardTags.isEmpty {
                LazyVGrid(columns: columnLayout) {
                    ForEach(hazardTags, id: \.self) { tag in
                        ZZSTag(text: tag,
                               textColor: Color.ChecklistTag.colorGray,
                               backgroundColor: Color.ChecklistTag.backgroundGray)
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Button.secondaryBlue)
                    .frame(height: 100)
                    .overlay(alignment: .center) {
                        Text(ZipLiteral.ResultCard.hazardSectioinEmptyText)
                            .foregroundStyle(Color.Text.secondary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }

    var RoomModel: some View {
        VStack(spacing: 0) {
            HStack {
                Text(ZipLiteral.ResultCard.roomModelSectionTitle)
                    .foregroundStyle(Color.Text.primary)
                    .applyZZSFont(zzsFontSet: .bodyBold)

                Spacer()
            }

            if let modelImage = homeData.modelImage {
                Image(uiImage: modelImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Background.disabled)
                    .frame(height: 140)
                    .overlay(alignment: .center) {
                        Text(ZipLiteral.ResultCard.roomModelSectionEmptyText)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }

    var NearbyFacilities: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(ZipLiteral.ResultCard.nearbySectionTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .bodyBold)
                .padding(.bottom, 12)

            if !availableFacility.isEmpty {
                HStack {
                    ForEach(availableFacility, id: \.self) { facility in
                        FacilityIcon(facility: facility)
                    }
                    Spacer()
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Background.disabled)
                    .frame(height: 29)
                    .overlay(alignment: .center) {
                        Text(ZipLiteral.ResultCard.nearbySectionEmptyText)
                            .foregroundStyle(Color.Text.tertiary)
                            .applyZZSFont(zzsFontSet: .subheadlineRegular)
                    }
            }
        }
        .padding(16)
    }

    @ViewBuilder
    func FacilityIcon(facility: Facility) -> some View {
        let icon = Image(facility.icon)
            .resizable()
            .scaledToFit()
            .frame(width: 29, height: 29)

        switch layout {
        case .capture:
            icon
        case .interactive:
            icon
                .onTapGesture {
                    withAnimation() {
                        selectedFacility = facility.rawValue
                        showBubble = true
                    }

                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        withAnimation() {
                            showBubble = false
                        }
                    }
                }
                .overlay {
                    if showBubble && selectedFacility == facility.rawValue {
                        Text(facility.rawValue)
                            .fixedSize()
                            .lineLimit(1)
                            .foregroundStyle(Color.Text.onColorPrimary)
                            .applyZZSFont(zzsFontSet: .caption1Regular)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.7))
                            )
                            .offset(y: -30)
                            .transition(.opacity)
                    }
                }
        }
    }
}

// MARK: - Header

struct ZZSShareCardHeader: View {
    @Binding var homeData: HomeData
    let layout: ZZSShareCard.Layout

    @State private var displayImage: UIImage?

    var body: some View {
        Image(uiImage: headerImage ?? .basicYongboogiHead)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.screenSize.width-32, height: 340)
            .overlay(Color.black.opacity(0.3))
            .overlay {
                if headerImage == nil {
                    Rectangle()
                        .fill(Color.Button.tertiary)
                        .frame(width: UIScreen.screenSize.width-32, height: 340)
                        .overlay {
                            Image(.charResultCard)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 130)
                        }
                }
            }
            .overlay(contentOverlay)
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16, topTrailing: 16)))
            .task {
                if layout == .interactive {
                    await displayImage = loadImage()
                }
            }
    }

    /// 캡처는 스냅샷 시점 프레임을 그대로 찍으므로 사진을 즉시 그려야 한다.
    private var headerImage: UIImage? {
        switch layout {
        case .interactive: return displayImage
        case .capture: return homeData.homeImage
        }
    }
}

private extension ZZSShareCardHeader {
    // MARK: - View

    var contentOverlay: some View {
        VStack(spacing: 0) {
            HomeNicknameAndType
            HomeAddress
            Spacer()
            HomeTags
        }
        .padding(8)
        .frame(height: 340)
    }

    var HomeNicknameAndType: some View {
        HStack(alignment: .top) {
            Text(homeData.homeName)
                .foregroundStyle(Color.Tag.colorWhite)
                .applyZZSFont(zzsFontSet: .headline)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.Tag.backgroundWhite)
                )
            Spacer()

            if let type = homeData.homeCategoryType?.text {
                Text(type)
                    .foregroundStyle(Color.Text.onColorSecondary)
                    .applyZZSFont(zzsFontSet: .bodyBold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.Text.onColorSecondary, lineWidth: 1)
                    }
            }
        }
        .padding(.bottom, 6)
    }

    var HomeAddress: some View {
        HStack {
            Text(homeData.locationText ?? "등록된 주소가 없어요")
                .foregroundStyle(Color.Text.onColorPrimary)
                .applyZZSFont(zzsFontSet: .bodyBold)
            Spacer()
        }
    }

    var HomeTags: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                if homeData.homeAreaPyeong != "" && homeData.homeAreaSquareMeter != "" {
                    ZZSTag(text: "\(homeData.homeAreaPyeong)평/\(homeData.homeAreaSquareMeter)m²")
                    ZZSTag(text: "월세 \(monthlyFee)")
                } else {
                    ZZSTag(text: "월세 \(monthlyFee)")
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 28)
                }

            }

            HStack(spacing: 6) {
                ZZSTag(text: "보증금 \(deposit)")
                ZZSTag(text: "관리비 \(managementFee)")
            }
        }
    }

    // MARK: - Computed Values

    var rentalFeeStrings: [String] {
        return homeData.rentalFeeData.sorted {
            $0.index < $1.index
        }.map { rentalFee in
            return rentalFee.value
        }
    }

    var monthlyFee: String {
        if homeData.homeRentalType == .fullDeposit {
            return "없음"
        } else {
            return rentalFeeStrings[safe: 2]?.isEmpty == false ? "\(rentalFeeStrings[2])만원" : "없음"
        }
    }

    var managementFee: String {
        return rentalFeeStrings[safe: 3]?.isEmpty == false ? "\(rentalFeeStrings[3])만원" : "없음"
    }

    var deposit: String {
        let small = rentalFeeStrings[safe: 0] ?? ""
        let large = rentalFeeStrings[safe: 1] ?? ""
        if small.isEmpty && large.isEmpty {
            return "없음"
        } else if small.isEmpty {
            return "\(large)억"
        } else if large.isEmpty {
            return "\(small)만원"
        } else {
            return "\(large)억 \(small)만원"
        }
    }

    func loadImage() async -> UIImage? {
        try? await Task.sleep(nanoseconds: 50_000_000)
        return homeData.homeImage
    }
}
