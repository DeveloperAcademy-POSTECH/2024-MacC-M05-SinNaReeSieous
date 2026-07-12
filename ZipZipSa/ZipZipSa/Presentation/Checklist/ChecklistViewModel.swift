//
//  ChecklistViewModel.swift
//  ZipZipSa
//

import Foundation
import Observation

/// 체크리스트 화면의 상태와 로직.
/// 기존 ChecklistView(첫 기록)와 DetailChecklistView(재열람/수정)에 복붙되어 있던
/// 필터·답변·저장 로직을 모드 하나로 흡수했다.
@Observable
@MainActor
final class ChecklistViewModel {

    enum Mode {
        /// 집 보러가기 플로우의 첫 기록. 카테고리는 User의 관심사를 쓰고,
        /// 기록 시점의 카테고리를 HomeData에 스냅샷으로 남긴다. 마지막 버튼 = 구조 스캔.
        case homeHunt
        /// 저장된 집의 재열람/수정. 카테고리는 기록 당시 스냅샷을 쓴다. 마지막 버튼 = 저장.
        case review
    }

    let mode: Mode

    private(set) var selectedCategories: [ChecklistCategory] = []
    private(set) var answers: [String: Set<Int>] = [:]
    private(set) var scores: [String: Float] = [:]

    /// homeHunt에서 사용 중인 템플릿. nil이면 기본(관심 카테고리 동적 규칙).
    private(set) var template: ChecklistTemplateData?
    /// review 재현용 — 기록 당시 노출됐던 질문 code 스냅샷.
    private var snapshotCodes: [String] = []
    /// homeHunt에서 기본 템플릿의 카테고리 소스로 쓰는 유저 관심사.
    private var userFavorites: [ChecklistCategory] = []

    init(mode: Mode) {
        self.mode = mode
    }

    // MARK: - 질문 목록

    var filteredItems: [ChecklistItem] {
        if mode == .review && !snapshotCodes.isEmpty {
            // 템플릿이 이후 수정/삭제돼도 과거 기록은 당시 질문 세트로 재현한다
            let codes = Set(snapshotCodes)
            return ChecklistItem.checklistItems.filter { codes.contains($0.code) }
        }
        return QuestionProvider.questions(for: template, selectedCategories: selectedCategories)
    }

    func items(for spaceType: SpaceType) -> [ChecklistItem] {
        filteredItems
            .filter { $0.space.type == spaceType }
            .sorted { $0.space.questionNumber < $1.space.questionNumber }
    }

    // MARK: - 화면 문구/분기

    var navigationTitle: String {
        switch mode {
        case .homeHunt: return ZipLiteral.Checklist.navigationTitle
        case .review: return "체크리스트예요"
        }
    }

    func isLastSpace(_ spaceType: SpaceType) -> Bool {
        spaceType == SpaceType.allCases.last
    }

    func bottomButtonText(for spaceType: SpaceType) -> String {
        guard isLastSpace(spaceType) else { return "다음" }
        switch mode {
        case .homeHunt: return ZipLiteral.Checklist.bottomButton
        case .review: return "저장"
        }
    }

    // MARK: - 답변

    func isSelected(item: ChecklistItem, index: Int) -> Bool {
        answers[item.code]?.contains(index) ?? false
    }

    func toggleAnswer(item: ChecklistItem, index: Int) {
        let isSelected = isSelected(item: item, index: index)
        switch item.question.answerType {
        case .multiSelect:
            if isSelected {
                answers[item.code]?.remove(index)
            } else {
                answers[item.code, default: Set()].insert(index)
            }
        case .multiChoices, .twoChoices:
            if isSelected {
                answers[item.code] = nil
            } else {
                answers[item.code] = Set([index])
            }
        }
        scores[item.code] = ChecklistScoringService.answerScore(
            for: item,
            selection: answers[item.code]
        )
    }

    // MARK: - 로드/저장

    /// 화면 진입 시 호출. 카테고리를 결정하고 저장된 답변을 불러온다.
    /// activeTemplate: homeHunt에서 시작할 템플릿(대표 템플릿). nil이면 기본 규칙.
    func start(
        homeData: HomeData,
        userFavorites: [ChecklistCategory],
        activeTemplate: ChecklistTemplateData? = nil
    ) {
        switch mode {
        case .homeHunt:
            self.userFavorites = userFavorites
            applyTemplate(activeTemplate, homeData: homeData)
        case .review:
            snapshotCodes = homeData.usedQuestionCodes
            selectedCategories = homeData.selectedCategories
        }

        if !homeData.checklistAnswers.isEmpty {
            answers = homeData.checklistAnswersByCode
        } else if let legacy = homeData.loadDictionary(data: homeData.answerData, type: [Int: Set<Int>].self) {
            // 마이그레이터가 아직 돌지 않은 예외 상황 대비 폴백
            answers = LegacyChecklistIDMap.fromLegacy(legacy)
        }
        scores = ChecklistScoringService.deriveScores(answers: answers)
    }

    /// homeHunt 전용 — 집 보기 세션 도중 체크리스트 전환.
    /// 대표 설정(activeTemplateID)은 건드리지 않고 이 세션의 질문 세트만 바꾼다.
    /// 답변은 code 기반이라 전환해도 유지되며, 세트 밖 질문은 화면/점수에서만 제외된다.
    func switchTemplate(_ template: ChecklistTemplateData?, homeData: HomeData) {
        guard mode == .homeHunt else { return }
        applyTemplate(template, homeData: homeData)
    }

    /// 템플릿을 적용하고 채점 카테고리를 재계산해 HomeData에 스냅샷을 남긴다.
    private func applyTemplate(_ template: ChecklistTemplateData?, homeData: HomeData) {
        self.template = (template?.isDefault == true) ? nil : template
        if let template = self.template {
            let items = QuestionProvider.questions(for: template, selectedCategories: [])
            selectedCategories = QuestionProvider.scoringCategories(for: items)
        } else {
            selectedCategories = userFavorites
        }
        homeData.selectedCategoryData = selectedCategories.map {
            ChecklistCategoryData(rawValue: $0.rawValue)
        }
    }

    /// V2: 답변 레코드가 원본. 레거시 blob은 롤백 대비 미러로만 함께 기록한다.
    func save(to homeData: HomeData) {
        homeData.setChecklistAnswers(answers)
        homeData.usedQuestionCodes = filteredItems.map(\.code)
        if let answerData = homeData.saveDictionary(dictionary: LegacyChecklistIDMap.toLegacy(answers)) {
            homeData.answerData = answerData
        }
        if let scoreData = homeData.saveDictionary(dictionary: LegacyChecklistIDMap.toLegacy(scores)) {
            homeData.scoreData = scoreData
        }
    }

    /// 카테고리별 점수·만점·위험요소를 계산해 결과 카드용 필드에 저장한다.
    func applyResult(to homeData: HomeData) {
        let categoryScoreResult = ChecklistScoringService.categoryScores(
            items: filteredItems,
            selectedCategories: selectedCategories,
            scores: scores
        )
        let maxCategoryScoreResult = ChecklistScoringService.maxCategoryScores(
            items: filteredItems,
            selectedCategories: selectedCategories
        )
        let hazardResult = ChecklistScoringService.hazards(
            items: filteredItems,
            answers: answers
        )
        homeData.resultScoreData = homeData.saveDictionary(dictionary: categoryScoreResult)
        homeData.resultMaxScoreData = homeData.saveDictionary(dictionary: maxCategoryScoreResult)
        homeData.resultHazardData = hazardResult.map { HazardData(rawValue: $0.rawValue) }
    }
}
