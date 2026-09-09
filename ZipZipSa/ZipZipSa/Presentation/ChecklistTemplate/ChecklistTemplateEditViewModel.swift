//
//  ChecklistTemplateEditViewModel.swift
//  ZipZipSa
//

import Foundation
import Observation
import SwiftData

/// 커스텀 체크리스트 생성/수정 플로우(질문 선택 → 이름 입력)의 상태와 저장 로직.
@Observable
@MainActor
final class ChecklistTemplateEditViewModel {

    static let maxNameLength = 14

    /// 수정 대상. nil이면 새 템플릿 생성.
    private(set) var template: ChecklistTemplateData?

    var name: String = ""
    var isPrimary: Bool = false
    private(set) var selectedCodes: Set<String> = []

    private var started = false

    init(template: ChecklistTemplateData? = nil) {
        self.template = template
    }

    var isNew: Bool { template == nil }

    var isValid: Bool { !selectedCodes.isEmpty }

    /// 편집 화면 타이틀의 첫 줄. 수정이면 템플릿 이름, 신규면 안내 문구.
    var displayName: String {
        isNew ? ZipLiteral.ChecklistTemplate.newTemplateTitleName : name
    }

    /// 화면 진입 시 호출. 수정이면 기존 값을, 신규면 기본 규칙 세트를 초기값으로 채운다.
    func start(user: User?) {
        guard !started else { return }
        started = true

        if let template {
            name = template.name
            selectedCodes = Set(template.questionCodes)
            isPrimary = user?.activeTemplateID == template.id
        } else {
            let defaultItems = QuestionProvider.questions(
                selectedCategories: user?.favoriteCategories ?? []
            )
            selectedCodes = Set(defaultItems.map(\.code))
        }
    }

    // MARK: - 질문 선택

    /// 선택된 질문 (공간별, 카탈로그 연번 순).
    func includedItems(for spaceType: SpaceType) -> [ChecklistItem] {
        items(for: spaceType).filter { selectedCodes.contains($0.code) }
    }

    /// 아직 선택되지 않은 질문 (공간별, 카탈로그 연번 순).
    func availableItems(for spaceType: SpaceType) -> [ChecklistItem] {
        items(for: spaceType).filter { !selectedCodes.contains($0.code) }
    }

    func add(_ item: ChecklistItem) {
        selectedCodes.insert(item.code)
    }

    func remove(_ item: ChecklistItem) {
        selectedCodes.remove(item.code)
    }

    private func items(for spaceType: SpaceType) -> [ChecklistItem] {
        ChecklistItem.checklistItems
            .filter { $0.space.type == spaceType }
            .sorted { $0.space.questionNumber < $1.space.questionNumber }
    }

    // MARK: - 저장

    /// 템플릿을 저장한다. 이름이 비어 있으면 "내 체크리스트 N"으로 채우고,
    /// 대표 체크박스 상태를 User.activeTemplateID에 반영한다.
    func save(context: ModelContext) {
        guard isValid else { return }
        let user = UserService.fetchOrCreateUser(context: context)

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? defaultName(user: user) : trimmedName
        // 노출 순서는 공간·연번 기준이지만, 저장도 카탈로그 순서로 정규화해둔다
        let orderedCodes = ChecklistItem.checklistItems
            .filter { selectedCodes.contains($0.code) }
            .map(\.code)

        let saved: ChecklistTemplateData
        if let template {
            template.name = finalName
            template.questionCodes = orderedCodes
            saved = template
        } else {
            let newTemplate = ChecklistTemplateData(name: finalName, questionCodes: orderedCodes)
            user.templates.append(newTemplate)
            saved = newTemplate
        }

        if isPrimary {
            user.activeTemplateID = saved.id
        } else if user.activeTemplateID == saved.id {
            // 대표였던 템플릿에서 체크를 해제하면 기본 체크리스트가 대표가 된다
            user.activeTemplateID = nil
        }
        try? context.save()
    }

    private func defaultName(user: User) -> String {
        "내 체크리스트 \(user.templates.count + 1)"
    }
}
