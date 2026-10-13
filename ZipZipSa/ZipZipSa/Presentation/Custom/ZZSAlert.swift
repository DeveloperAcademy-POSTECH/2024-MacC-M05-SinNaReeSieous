//
//  ZZSAlert.swift
//  ZipZipSa
//

import UIKit

enum ZZSAlertAppearance {

    /// 시스템 알럿의 '취소' 버튼을 시안대로 파란색으로 맞춘다.
    ///
    /// 알럿 버튼 색은 SwiftUI 환경 tint가 아니라 UIKit 윈도우의 tintColor를 따라간다.
    /// 이 앱의 AccentColor가 갈색(#827460)이라 그대로 두면 '취소'가 갈색으로 나오는데,
    /// 알럿 안의 뷰로 범위를 좁혀 지정하면 다른 화면 색은 그대로 두고 알럿만 바꿀 수 있다.
    /// destructive 버튼은 역할에 따라 항상 빨간색이라 영향받지 않는다.
    static func apply() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            .tintColor = .systemBlue
    }
}
