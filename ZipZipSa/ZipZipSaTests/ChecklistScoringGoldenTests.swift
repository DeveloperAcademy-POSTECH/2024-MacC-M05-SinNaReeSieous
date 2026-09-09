//
//  ChecklistScoringGoldenTests.swift
//  ZipZipSaTests
//

import Testing
@testable import ZipZipSa

/// 점수 계산의 골든(특성화) 테스트.
/// 리터럴 기대값은 리팩토링 이전(뷰 내부에 로직이 있던 시절)과 동일한 알고리즘으로
/// 계산한 실제 결과를 고정한 것이다. 이 테스트가 깨지면 점수 체계의 동작이 바뀐 것이므로,
/// 의도한 변경(예: 가중치 조정)이 아닌 한 회귀로 간주해야 한다.
struct ChecklistScoringGoldenTests {

    /// 앱과 동일한 방식으로 답변 세트에서 개별 점수 딕셔너리를 파생시킨다.
    /// (실제 앱에서는 답변 버튼을 누를 때마다 answerScore가 scores에 기록된다)
    private func deriveScores(items: [ChecklistItem], answers: [String: Set<Int>]) -> [String: Float] {
        var scores: [String: Float] = [:]
        for item in items {
            if let selection = answers[item.code] {
                scores[item.code] = ChecklistScoringService.answerScore(for: item, selection: selection)
            }
        }
        return scores
    }

    private func result(
        favorites: [ChecklistCategory],
        answers: [String: Set<Int>]
    ) -> (category: [String: Float], max: [String: Float], hazards: [Hazard], itemCount: Int) {
        let items = ChecklistScoringService.filteredItems(selectedCategories: favorites)
        let scores = deriveScores(items: items, answers: answers)
        return (
            ChecklistScoringService.categoryScores(items: items, selectedCategories: favorites, scores: scores),
            ChecklistScoringService.maxCategoryScores(items: items, selectedCategories: favorites),
            ChecklistScoringService.hazards(items: items, answers: answers),
            items.count
        )
    }

    @Test func 전체_관심카테고리_전부_첫옵션_응답() {
        let r = result(favorites: ChecklistAnswerFixtures.allFavorites,
                       answers: ChecklistAnswerFixtures.allFirstOption)
        #expect(r.itemCount == 57)
        #expect(r.category == [
            "cleanliness": 0.0, "insectproof": 0.0, "security": 2.0,
            "soundproof": 1.5, "sunlight": 0.0, "ventilation": 0.0
        ])
        #expect(r.max == [
            "cleanliness": 36.0, "insectproof": 18.0, "security": 20.5,
            "soundproof": 10.0, "sunlight": 8.0, "ventilation": 18.0
        ])
        // 첫 옵션은 전부 위험 응답이므로 hazard 9종 전체가 수집된다 (한글명 정렬 순서).
        #expect(r.hazards.map(\.rawValue) == [
            "mold", "waterLeak", "cigaretteSmell", "cockroach", "waterDrainage",
            "privacy", "noise", "waterPressure", "waterCold"
        ])
    }

    @Test func 전체_관심카테고리_전부_마지막옵션_응답() {
        let r = result(favorites: ChecklistAnswerFixtures.allFavorites,
                       answers: ChecklistAnswerFixtures.allLastOption)
        #expect(r.category == [
            "cleanliness": 36.0, "insectproof": 18.0, "security": 18.0,
            "soundproof": 9.5, "sunlight": 8.0, "ventilation": 18.0
        ])
        #expect(r.max == [
            "cleanliness": 36.0, "insectproof": 18.0, "security": 20.5,
            "soundproof": 10.0, "sunlight": 8.0, "ventilation": 18.0
        ])
        #expect(r.hazards.isEmpty)
    }

    @Test func 두_관심카테고리_짝수id만_첫옵션_응답() {
        let r = result(favorites: ChecklistAnswerFixtures.twoFavorites,
                       answers: ChecklistAnswerFixtures.evenIdsFirstOption)
        #expect(r.itemCount == 48)
        #expect(r.category == [
            "cleanliness": 6.0, "insectproof": 2.0, "security": 7.5,
            "soundproof": 3.0, "sunlight": 1.0, "ventilation": 1.0
        ])
        #expect(r.max == [
            "cleanliness": 24.0, "insectproof": 8.0, "security": 20.5,
            "soundproof": 10.0, "sunlight": 6.0, "ventilation": 8.0
        ])
        #expect(r.hazards.map(\.rawValue) == ["privacy", "noise", "waterCold"])
    }

    @Test func 관심카테고리_없음_전부_미응답() {
        // 미응답 질문의 기본값 가산 규칙(multiSelect는 basicScore, 그 외 1.0)이 지켜지는지 확인.
        let r = result(favorites: ChecklistAnswerFixtures.noFavorites,
                       answers: ChecklistAnswerFixtures.unanswered)
        #expect(r.itemCount == 44)
        #expect(r.category == [
            "cleanliness": 12.0, "insectproof": 4.0, "security": 3.0,
            "soundproof": 6.0, "sunlight": 3.0, "ventilation": 4.0
        ])
        #expect(r.max == [
            "cleanliness": 24.0, "insectproof": 8.0, "security": 8.5,
            "soundproof": 10.0, "sunlight": 6.0, "ventilation": 8.0
        ])
        #expect(r.hazards.isEmpty)
    }

    @Test func 전체_관심카테고리_multiSelect만_전체선택() {
        // 선택 개수 비례(±0.5) 점수 규칙 확인.
        let r = result(favorites: ChecklistAnswerFixtures.allFavorites,
                       answers: ChecklistAnswerFixtures.multiSelectAllOptions)
        #expect(r.category == [
            "cleanliness": 18.0, "insectproof": 9.0, "security": 10.5,
            "soundproof": 4.0, "sunlight": 4.0, "ventilation": 9.0
        ])
        #expect(r.hazards.isEmpty)
    }

    @Test func 답변_점수_규칙_단건_검증() {
        // twoChoices: 미선택 1점 / 부정(0번) 0점 / 긍정(1번) 2점
        let twoChoices = ChecklistItem.checklistItems.first { item in
            if case .twoChoices = item.question.answerType { return true }
            return false
        }!
        #expect(ChecklistScoringService.answerScore(for: twoChoices, selection: nil) == 1)
        #expect(ChecklistScoringService.answerScore(for: twoChoices, selection: [0]) == 0)
        #expect(ChecklistScoringService.answerScore(for: twoChoices, selection: [1]) == 2)

        // multiChoices: 선택 인덱스가 곧 점수
        let multiChoices = ChecklistItem.checklistItems.first { item in
            if case .multiChoices = item.question.answerType { return true }
            return false
        }!
        #expect(ChecklistScoringService.answerScore(for: multiChoices, selection: nil) == 1)
        #expect(ChecklistScoringService.answerScore(for: multiChoices, selection: [2]) == 2)

        // multiSelect(negative): basicScore에서 선택당 -0.5
        let negativeMultiSelect = ChecklistItem.checklistItems.first { item in
            if case .multiSelect(_, .negative) = item.question.answerType { return true }
            return false
        }!
        guard case .multiSelect(let basicScore, _) = negativeMultiSelect.question.answerType else {
            Issue.record("multiSelect 케이스 매칭 실패")
            return
        }
        #expect(ChecklistScoringService.answerScore(for: negativeMultiSelect, selection: []) == basicScore)
        #expect(ChecklistScoringService.answerScore(for: negativeMultiSelect, selection: [0, 1]) == basicScore - 1.0)
    }
}
