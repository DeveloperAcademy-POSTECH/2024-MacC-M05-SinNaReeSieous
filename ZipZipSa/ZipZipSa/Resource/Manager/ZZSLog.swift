//
//  ZZSLog.swift
//  ZipZipSa
//

import Foundation
import os

/// 앱 공용 로거. print 대신 사용한다.
/// print와 달리 릴리스 빌드에서도 Console.app에서 추적할 수 있고, 로그 레벨이 구분된다.
enum ZZSLog {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ZipZipSa",
        category: "app"
    )

    static func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }

    static func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }
}
