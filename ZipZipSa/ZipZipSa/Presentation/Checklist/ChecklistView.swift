//
//  ChecklistView.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI
import RoomPlan
import SwiftData

struct ChecklistView: View {
    @Binding var showHomeHuntSheet: Bool
    @Binding var homeData: HomeData
    @Query var users: [User]
    var user: User { users[0] }
    var userFavoriteCategoryData: [ChecklistCategory] {
        user.favoriteCategories
    }
    
    @Binding var selectedSpaceType: SpaceType
    @Binding var firstShow: Bool
    
    @State private var answers: [UUID: Set<Int>] = [:]
    @State private var scores: [UUID: Float] = [:]
    
    @State private var model: UIImage? = nil
    @State private var moveToRoomScanInfoView: Bool = false
    @State private var moveToUnsupportedDeviceView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    NavigationBarTitle
                    ChecklistList
                }
            }
            .clipped()
            .scrollIndicators(.never)
            .contentMargins(.bottom, 120, for: .scrollContent)
        }
        .overlay(alignment: .bottom) {
            ZZSMainButton(
                action: {
                    moveNextStep()
                },
                text: bottomButtonText
            )
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)
            .background(Color.Background.primary)
        }
        .onAppear {
            // 오류 해결을 위한 임시방편 코드
            if firstShow {
                selectedSpaceType = .livingRoom
                firstShow = false
            }
            
            // 그 당시의 선택 카테고리 저장
            applyUserDataToHomeData()
            applyHomeDataToViewState()
        }
        .onDisappear {
            applyViewStateToHomeData()
        }
        .background(Color.Background.primary)
        .dismissKeyboard()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $moveToRoomScanInfoView) {
            RoomScanInfoView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)
        }
        .navigationDestination(isPresented: $moveToUnsupportedDeviceView) {
            UnsupportedDeviceView(model: $model, homeData: $homeData, showHomeHuntSheet: $showHomeHuntSheet)
        }
    }
}

private extension ChecklistView {
    
    // MARK: - View
    
    var ChecklistList: some View {
        ScrollViewReader { scrollView in
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    Spacer().frame(height: 18)
                    ForEach(spaceChecklistItems) { checklistItem in
                        ChecklistRowView(
                            selectedCategory: user.favoriteCategories,
                            answers: $answers,
                            scores: $scores,
                            checklistItem: checklistItem
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                    Memo
                    
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
    
    var NavigationBarTitle: some View {
        HStack {
            Text(ZipLiteral.Checklist.navigationTitle)
                .foregroundStyle(Color.Text.primary)
                .applyZZSFont(zzsFontSet: .largeTitle)
            Spacer()
        }
        .padding(.horizontal, 16)
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
                    if homeData.memoData[selectedSpaceType.rawValue].value.isEmpty {
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
    
    // MARK: - Computed Values
    
    var filteredChecklistItems: [ChecklistItem] {
        ChecklistItem.checklistItems.filter {
            let isBasicCheckListItem = $0.checkListType == .basic
            let isSelectedCategoryCheckListItem = $0.checkListType == .advanced
            && user.favoriteCategories.contains($0.basicCategory)
            return isBasicCheckListItem || isSelectedCategoryCheckListItem
        }
    }
    
    var spaceChecklistItems: [ChecklistItem] {
        return filteredChecklistItems.filter {
            $0.space.type == selectedSpaceType
        }
        .sorted { $0.space.questionNumber < $1.space.questionNumber }
    }
    
    var bottomButtonText: String {
        if selectedSpaceType.rawValue == 4 {
            return "집 구조 스캔하기"
        } else {
            return "다음"
        }
    }
    
    // MARK: - Action
    
    func moveNextStep() {
        if selectedSpaceType.rawValue == 4 {
            applyChecklistResult()
            if RoomCaptureSession.isSupported {
                moveToRoomScanInfoView = true
            } else {
                moveToUnsupportedDeviceView = true
            }
        } else {
            let nextSpaceType = SpaceType(rawValue: selectedSpaceType.rawValue + 1)
            if let nextSpaceType {
                selectedSpaceType = nextSpaceType
            }
        }
    }
    
    func applyUserDataToHomeData() {
        homeData.selectedCategoryData = userFavoriteCategoryData.map { ChecklistCategoryData(rawValue: $0.rawValue) }
    }
    
    func applyViewStateToHomeData() {
        if let answerData = homeData.saveDictionary(dictionary: answers) {
            homeData.answerData = answerData
        }
        if let scoreData = homeData.saveDictionary(dictionary: scores) {
            homeData.scoreData = scoreData
        }
    }
    
    func applyHomeDataToViewState() {
        if let answers = homeData.loadDictionary(data: homeData.answerData, type: [UUID: Set<Int>].self) {
            self.answers = answers
        }
        if let scores = homeData.loadDictionary(data: homeData.scoreData, type: [UUID: Float].self) {
            self.scores = scores
        }
    }
    
    // MARK: - Custom Method
    
    func applyChecklistResult() {
        homeData.resultScoreData = homeData.saveDictionary(dictionary: calculateCategoryScoreResult())
        homeData.resultMaxScoreData = homeData.saveDictionary(dictionary: calculateMaxCategoryScoreResult())
        homeData.resultHazardData = getHazardResult().map { HazardData(rawValue: $0.rawValue) }
        print("현재 점수")
        print(calculateCategoryScoreResult())
        print("최대 점수")
        print(calculateMaxCategoryScoreResult())
        print("위험 요소")
        print(getHazardResult())
    }
    
    func calculateCategoryScoreResult() -> [String: Float] {
        var categoryScores: [String: Float] = [:]
        
        filteredChecklistItems.forEach { checklistItem in
            let categories = [checklistItem.basicCategory] + checklistItem.crossTip.keys
            
            for category in categories {
                let isSelectableBasicCategory = checklistItem.basicCategory == category && category.isSelectable
                if user.favoriteCategories.contains(category) || isSelectableBasicCategory {
                    var basicValue: Float = 0.0
                    switch checklistItem.question.answerType {
                    case .multiSelect(let basicScore, _):
                        basicValue = basicScore
                    default:
                        basicValue = 1.0
                    }
                    categoryScores[category.rawValue, default: 0.0] += scores[checklistItem.id] ?? basicValue
                }
            }
        }
        
        return categoryScores
    }
    
    func calculateMaxCategoryScoreResult() -> [String: Float] {
        var categoryScores: [String: Float] = [:]
        
        filteredChecklistItems.forEach { checklistItem in
            let categories = [checklistItem.basicCategory] + checklistItem.crossTip.keys
            
            for category in categories {
                let isSelectableBasicCategory = checklistItem.basicCategory == category && category.isSelectable
                if user.favoriteCategories.contains(category) || isSelectableBasicCategory {
                    switch checklistItem.question.answerType {
                    case .multiSelect(let basicScore, let answerDisposition):
                        if answerDisposition == .negative {
                            categoryScores[category.rawValue, default: 0.0] += basicScore
                        } else if answerDisposition == .positive {
                            let maxScore: Float = Float(checklistItem.question.answerOptions.count) * 0.5
                            categoryScores[category.rawValue, default: 0.0] += maxScore
                        }
                    default:
                        categoryScores[category.rawValue, default: 0.0] += 2.0
                    }
                }
            }
        }
        
        return categoryScores
    }
    
    func getHazardResult() -> [Hazard] {
        var hazards: [Hazard] = []
        
        filteredChecklistItems.forEach { checklistItem in
            guard let hazard = checklistItem.hazard else {
                return
            }
            let hasHazard = answers[checklistItem.id] == [0]
            if hasHazard && !hazards.contains(hazard) {
                hazards.append(hazard)
            }
        }
        
        hazards.sort { $0.text < $1.text }
        
        return hazards
    }
}
//
//#Preview {
//    NavigationView {
//        ChecklistView()
//    }
//}
