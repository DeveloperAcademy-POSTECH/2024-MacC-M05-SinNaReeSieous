//
//  UserService.swift
//  ZipZipSa
//

import Foundation
import SwiftData

/// User 레코드 접근의 단일 창구.
/// 기존 코드 곳곳의 `users[0]` 강제 인덱싱(User가 없으면 크래시)을 대체한다.
enum UserService {

    @MainActor
    static func fetchUser(context: ModelContext) -> User? {
        try? context.fetch(FetchDescriptor<User>()).first
    }

    @MainActor
    static func fetchOrCreateUser(context: ModelContext) -> User {
        if let user = fetchUser(context: context) {
            return user
        }
        let user = User()
        context.insert(user)
        return user
    }
}
