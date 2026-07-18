//
//  ChecklistTemplatePresetTests.swift
//  ZipZipSaTests
//

import Testing
@testable import ZipZipSa

struct ChecklistTemplatePresetTests {

    @Test func 프리셋_질문_수() {
        #expect(ChecklistTemplatePreset.quick.questionCount == 10)
        #expect(ChecklistTemplatePreset.basic.questionCount == 44)
        #expect(ChecklistTemplatePreset.detailed.questionCount == ChecklistItem.checklistItems.count)
        #expect(ChecklistTemplatePreset.custom.questionCount == 0)
    }

    @Test func 프리셋_포함_관계() {
        let quick = Set(ChecklistTemplatePreset.quick.questionCodes)
        let basic = Set(ChecklistTemplatePreset.basic.questionCodes)
        let detailed = Set(ChecklistTemplatePreset.detailed.questionCodes)
        #expect(quick.isSubset(of: basic))
        #expect(basic.isSubset(of: detailed))
    }

    @Test func 기본_프리셋은_레거시_기본_세트와_같다() {
        // 빠르게는 기본에서 세분화된 유형이므로, 관심 카테고리가 없을 때의
        // 기존 기본 체크리스트와 같은 세트여야 한다 (레거시 동작 보존).
        let legacyDefault = ChecklistScoringService.filteredItems(selectedCategories: []).map(\.code)
        #expect(ChecklistTemplatePreset.basic.questionCodes == legacyDefault)
    }

    @Test func 빠르게_프리셋_구성() {
        // 노션 질문 정리 기준 "빠르게" 유형 (카탈로그 순서).
        #expect(ChecklistTemplatePreset.quick.questionCodes == [
            "ext-10",
            "lvr-05", "lvr-06", "lvr-13", "lvr-16",
            "win-04",
            "kit-06", "kit-08",
            "toi-05", "toi-07"
        ])
    }
}
