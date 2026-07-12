//
//  ChecklistItem.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/18/24.
//

import Foundation

struct ChecklistItem: Identifiable, Hashable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        lhs.code == rhs.code
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }

    /// 질문의 영구 식별자. 형식: "{공간 접두어}-{공간 내 연번}" (예: "ext-01", "lvr-21").
    /// 한 번 부여된 code는 절대 바꾸거나 재사용하지 않는다. 새 질문은 공간의 마지막 번호 뒤에 추가한다.
    /// 저장된 답변 데이터가 이 code를 키로 쓰므로, code가 바뀌면 사용자 기록이 유실된다.
    let code: String

    /// v1.0.2까지 저장 데이터의 키로 쓰던 정수 id. 레거시 blob 변환에만 사용한다.
    /// 주의: 30이 두 질문(lvr-21, kit-05)에 중복 부여된 이력이 있다. 새 질문에는 부여하지 않는다.
    let legacyID: Int

    let space: Space
    let checkListType: ChecklistType
    let basicCategory: ChecklistCategory
    let question: Question
    let crossTip: [ChecklistCategory: String]
    let remark: String?
    let hazard: Hazard?

    var id: String { code }

    init(
        legacyID: Int,
        code: String,
        space: Space,
        checkListType: ChecklistType,
        basicCategory: ChecklistCategory,
        question: Question,
        crossTip: [ChecklistCategory : String] = [:],
        remark: String? = nil,
        hazard: Hazard? = nil
    ) {
        self.legacyID = legacyID
        self.code = code
        self.space = space
        self.checkListType = checkListType
        self.basicCategory = basicCategory
        self.question = question
        self.crossTip = crossTip
        self.remark = remark
        self.hazard = hazard
    }
}

extension ChecklistItem {
    /// 전체 질문 카탈로그. 공간별 정의는 Domain/Catalog/ 아래 파일에 있다.
    static let checklistItems: [ChecklistItem] =
        exteriorItems + livingRoomItems + windowItems + kitchenItems + toiletItems

    /// code로 질문을 찾기 위한 조회 테이블.
    static let itemsByCode: [String: ChecklistItem] =
        Dictionary(uniqueKeysWithValues: checklistItems.map { ($0.code, $0) })
}



