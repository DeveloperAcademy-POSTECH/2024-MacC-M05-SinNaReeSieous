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
    /// 이 질문이 위험 응답일 때 붙는 위험요소. 한 질문이 여러 위험을 가리킬 수 있다.
    let hazards: [Hazard]

    /// 더 이상 쓰지 않는 질문. 카탈로그에서 지우지 않고 표시만 해둔다.
    /// 새로 만드는 체크리스트에는 절대 들어가지 않지만, 이미 답해서 저장된 기록은
    /// 질문 문구와 답변을 그대로 보여줘야 하므로 카탈로그에는 남긴다.
    let isRetired: Bool

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
        hazards: [Hazard] = [],
        isRetired: Bool = false
    ) {
        self.legacyID = legacyID
        self.code = code
        self.space = space
        self.checkListType = checkListType
        self.basicCategory = basicCategory
        self.question = question
        self.crossTip = crossTip
        self.remark = remark
        self.hazards = hazards
        self.isRetired = isRetired
    }
}

extension ChecklistItem {
    /// 칩으로 노출할 카테고리 — 대표 카테고리 + 크로스 카테고리 전부.
    /// 관심 카테고리 선택 여부와 무관하게 이 질문이 걸쳐 있는 카테고리를 모두 보여준다.
    /// crossTip은 Dictionary라 키 순서가 불안정하므로 allCases 순서로 고정한다.
    var displayCategories: [ChecklistCategory] {
        let crossCategories = ChecklistCategory.allCases.filter {
            $0 != basicCategory && crossTip.keys.contains($0)
        }
        return [basicCategory] + crossCategories
    }
}

extension ChecklistItem {
    /// 전체 질문 카탈로그. 공간별 정의는 Domain/Catalog/ 아래 파일에 있다.
    /// 은퇴한 질문도 포함한다 — 지난 기록을 재현하려면 문구가 필요하기 때문이다.
    static let checklistItems: [ChecklistItem] =
        exteriorItems + livingRoomItems + windowItems + kitchenItems + toiletItems

    /// 새로 만드는 체크리스트에 넣을 수 있는 질문. 은퇴한 질문은 빠진다.
    static let activeItems: [ChecklistItem] = checklistItems.filter { !$0.isRetired }

    /// code로 질문을 찾기 위한 조회 테이블.
    static let itemsByCode: [String: ChecklistItem] =
        Dictionary(uniqueKeysWithValues: checklistItems.map { ($0.code, $0) })
}



