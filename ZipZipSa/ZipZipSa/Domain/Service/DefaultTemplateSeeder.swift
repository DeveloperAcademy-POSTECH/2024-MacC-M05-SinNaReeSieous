//
//  DefaultTemplateSeeder.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// "기본" 체크리스트를 저장된 템플릿으로 한 번 만들어 둔다.
///
/// 예전에는 기본 체크리스트가 저장되지 않은 가상 행이라 수정·삭제할 수 없었다.
/// 처음 설치하자마자 바로 집을 볼 수 있도록 기본 + 대표로 시작하되,
/// 대표에서 해제된 뒤에는 다른 체크리스트처럼 수정·삭제할 수 있게 일반 템플릿으로 저장한다.
///
/// 사용자가 지운 뒤 다시 생기지 않도록 완료 여부를 UserDefaults에 둔다.
/// User가 아직 없으면(온보딩 전) 만들지 않고 다음 호출(온보딩 종료, 다음 실행)에서 다시 시도한다.
enum DefaultTemplateSeeder {

    static let seededKey = "didSeedDefaultTemplate"

    @MainActor
    static func seedIfNeeded(context: ModelContext, defaults: UserDefaults = .standard) {
        guard !defaults.bool(forKey: seededKey) else { return }
        guard let user = UserService.fetchUser(context: context) else { return }

        let codes = QuestionProvider.defaultQuestions()
            .filter { !$0.isRetired }
            .map(\.code)
        // 목록에서 항상 다른 체크리스트보다 먼저(생성 순서상 맨 앞) 오도록 한다
        let template = ChecklistTemplateData(
            name: ZipLiteral.ChecklistTemplate.defaultTemplateName,
            questionCodes: codes,
            createdAt: .distantPast
        )
        user.templates.append(template)

        // 대표가 없던(기본 체크리스트를 쓰던) 사용자는 저장된 기본을 대표로 이어서 쓴다
        if user.activeTemplate == nil {
            user.activeTemplateID = template.id
        }

        do {
            try context.save()
            defaults.set(true, forKey: seededKey)
        } catch {
            // 플래그를 올리지 않으므로 다음 실행에서 다시 시도된다.
        }
    }
}
