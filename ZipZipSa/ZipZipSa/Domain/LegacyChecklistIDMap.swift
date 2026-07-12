//
//  LegacyChecklistIDMap.swift
//  ZipZipSa
//

import Foundation

/// v1.0.2까지의 저장 데이터(정수 id 키 blob)와 새 code 체계 사이의 변환.
/// 카탈로그에서 파생되므로 질문 정의와 어긋날 수 없다.
///
/// legacyID 30은 두 질문(lvr-21 거실 세탁기, kit-05 주방 화구)에 중복 부여되어 있었고,
/// 기존 앱에서는 두 질문이 답변 상태를 공유했다(실제 버그).
/// - 읽기(레거시→code): 30의 값을 두 code 모두에 복제해 기존 점수를 정확히 보존한다.
/// - 쓰기(code→레거시): 두 code가 모두 30에 기록된다. code 정렬 순서로 순회하므로
///   마지막 값이 남는다. 저장 후 다시 읽으면 두 질문이 같은 값을 갖게 되어
///   기존 앱과 동일한 동작이다. (Phase 3의 code 키 저장 도입 시 해소)
enum LegacyChecklistIDMap {

    /// legacyID → 해당하는 code 목록 (30만 2개, 나머지는 1개)
    static let intToCodes: [Int: [String]] = {
        Dictionary(grouping: ChecklistItem.checklistItems, by: \.legacyID)
            .mapValues { $0.map(\.code).sorted() }
    }()

    /// code → legacyID
    static let codeToInt: [String: Int] = {
        Dictionary(uniqueKeysWithValues: ChecklistItem.checklistItems.map { ($0.code, $0.legacyID) })
    }()

    /// 레거시 blob에서 읽은 딕셔너리를 code 키로 변환한다 (중복 id는 값 복제).
    static func fromLegacy<Value>(_ legacy: [Int: Value]) -> [String: Value] {
        var result: [String: Value] = [:]
        for (legacyID, value) in legacy {
            for code in intToCodes[legacyID] ?? [] {
                result[code] = value
            }
        }
        return result
    }

    /// code 키 딕셔너리를 레거시 blob 형식(정수 id 키)으로 변환한다.
    static func toLegacy<Value>(_ modern: [String: Value]) -> [Int: Value] {
        var result: [Int: Value] = [:]
        for code in modern.keys.sorted() {
            if let legacyID = codeToInt[code], let value = modern[code] {
                result[legacyID] = value
            }
        }
        return result
    }
}
