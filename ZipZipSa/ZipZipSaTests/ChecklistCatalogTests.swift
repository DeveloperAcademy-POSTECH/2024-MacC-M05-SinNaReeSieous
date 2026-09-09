//
//  ChecklistCatalogTests.swift
//  ZipZipSaTests
//

import Testing
@testable import ZipZipSa

/// 질문 카탈로그(ChecklistItem.checklistItems)의 무결성을 검증한다.
/// 질문 데이터는 커스텀 체크리스트의 기반이므로, 카탈로그가 깨지면 여기서 먼저 잡혀야 한다.
struct ChecklistCatalogTests {

    @Test func 질문_개수는_57개다() {
        #expect(ChecklistItem.checklistItems.count == 57)
    }

    @Test func 질문_code는_유일해야_한다() {
        let codes = ChecklistItem.checklistItems.map(\.code)
        let duplicates = Dictionary(grouping: codes, by: { $0 })
            .filter { $1.count > 1 }
            .keys.sorted()
        #expect(duplicates.isEmpty, "중복된 code: \(duplicates)")
    }

    @Test func code_형식은_공간접두어_하이픈_두자리숫자다() {
        let validPrefixes = ["ext", "lvr", "win", "kit", "toi"]
        for item in ChecklistItem.checklistItems {
            let parts = item.code.split(separator: "-")
            #expect(parts.count == 2 && validPrefixes.contains(String(parts[0])) && parts[1].count == 2,
                    "형식에 어긋난 code: \(item.code)")
        }
    }

    @Test func 레거시_id_매핑은_전_질문을_커버한다() {
        // 모든 질문이 레거시 매핑에 존재해야 Phase 3 마이그레이션에서 누락이 없다.
        for item in ChecklistItem.checklistItems {
            #expect(LegacyChecklistIDMap.codeToInt[item.code] == item.legacyID)
            #expect(LegacyChecklistIDMap.intToCodes[item.legacyID]?.contains(item.code) == true)
        }
    }

    @Test func 레거시_id_30은_두_code로_복제_매핑된다() {
        // v1.0.2까지 id 30이 두 질문에 중복 부여되어 답변 상태를 공유했다.
        // 마이그레이션 시 30의 값을 두 질문 모두에 복제해야 기존 점수가 보존된다.
        #expect(LegacyChecklistIDMap.intToCodes[30] == ["kit-05", "lvr-21"])

        // 30 외의 중복은 없어야 한다.
        let otherDuplicates = LegacyChecklistIDMap.intToCodes
            .filter { $0.key != 30 && $0.value.count > 1 }
        #expect(otherDuplicates.isEmpty, "예상 밖의 legacyID 중복: \(otherDuplicates)")
    }

    @Test func 레거시_변환_왕복은_원본을_보존한다() {
        // 레거시 blob → code 키 → 레거시 blob 왕복에서 데이터가 유실되면 안 된다.
        let legacy: [Int: Set<Int>] = [0: [1], 3: [0, 2], 30: [1], 56: [0]]
        let roundTripped = LegacyChecklistIDMap.toLegacy(LegacyChecklistIDMap.fromLegacy(legacy))
        #expect(roundTripped == legacy)

        // 중복 id 30은 읽을 때 두 code로 복제된다.
        let modern = LegacyChecklistIDMap.fromLegacy(legacy)
        #expect(modern["lvr-21"] == [1])
        #expect(modern["kit-05"] == [1])
    }

    @Test func 모든_질문은_답변_옵션이_2개_이상이다() {
        for item in ChecklistItem.checklistItems {
            #expect(item.question.answerOptions.count >= 2,
                    "id \(item.id) 질문의 답변 옵션이 \(item.question.answerOptions.count)개")
        }
    }

    @Test func 답변_타입과_옵션_개수가_일치한다() {
        for item in ChecklistItem.checklistItems {
            switch item.question.answerType {
            case .twoChoices:
                #expect(item.question.answerOptions.count == 2,
                        "id \(item.id): twoChoices인데 옵션 \(item.question.answerOptions.count)개")
            case .multiChoices:
                #expect(item.question.answerOptions.count == 3,
                        "id \(item.id): multiChoices인데 옵션 \(item.question.answerOptions.count)개")
            case .multiSelect:
                #expect(item.question.answerOptions.count >= 2,
                        "id \(item.id): multiSelect인데 옵션 \(item.question.answerOptions.count)개")
            }
        }
    }

    @Test func 공간별_질문_번호는_공간_안에서_유일하다() {
        let grouped = Dictionary(grouping: ChecklistItem.checklistItems, by: { $0.space.type })
        for (space, items) in grouped {
            let numbers = items.map(\.space.questionNumber)
            let duplicates = Dictionary(grouping: numbers, by: { $0 })
                .filter { $1.count > 1 }
                .keys.sorted()
            #expect(duplicates.isEmpty, "\(space) 공간에서 중복된 질문 번호: \(duplicates)")
        }
    }

    @Test func 위험요소_질문은_첫_옵션이_위험_응답이다() {
        // 위험요소 수집(getHazardResult)은 답변이 [0]일 때 hazard로 판단한다.
        // hazard가 달린 질문이 twoChoices가 아니면 이 가정이 깨질 수 있어 방어한다.
        for item in ChecklistItem.checklistItems where item.hazard != nil {
            if case .twoChoices = item.question.answerType {
                continue
            }
            if case .multiChoices = item.question.answerType {
                continue
            }
            Issue.record("id \(item.id): hazard 질문의 answerType이 단일 선택이 아님 — 위험 판정 로직 확인 필요")
        }
    }
}
