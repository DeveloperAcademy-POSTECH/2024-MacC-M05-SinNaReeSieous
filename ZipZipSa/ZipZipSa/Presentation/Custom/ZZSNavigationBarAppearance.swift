//
//  ZZSNavigationBarAppearance.swift
//  ZipZipSa
//

import SwiftUI
import UIKit

enum ZZSNavigationBarAppearance {

    /// 시스템 네비게이션 바를 앱 디자인에 맞춘다.
    ///
    /// - 뒤로 버튼: 기존 커스텀 "< 뒤로"와 같게 Pretendard Medium 16, 20pt chevron.left, 갈색(#827460).
    /// - 바 배경(iOS 18 이하): 앱 배경색으로 채우고 구분선을 없앤다.
    ///   스크롤한 내용이 뒤로 버튼과 겹쳐 보이지 않으면서, 스크롤 전에는 바가 없는 것처럼 보인다.
    /// - iOS 26 이상은 시스템이 Liquid Glass와 스크롤 블러를 그리므로 건드리지 않는다.
    ///
    /// 화면별 .toolbarBackground(...)는 이 설정보다 우선하므로 화면에서 바 배경을 따로 지정하지 않는다.
    static func apply() {
        let tint = UIColor(Color.Button.tertiary)
        // 시스템 뒤로 버튼 화살표 색. iOS 26의 유리 뒤로 버튼도 이 색을 따른다.
        UINavigationBar.appearance().tintColor = tint

        if #available(iOS 26, *) {
            // iOS 26 유리 뒤로 버튼은 tint를 따르지 않아 화살표가 검은색으로 나온다.
            // 화살표 이미지 자체를 갈색으로 고정하고, 배경 등 나머지는 시스템 기본(유리·스크롤 블러)을 그대로 둔다.
            let appearance = UINavigationBarAppearance()
            let chevron = UIImage(systemName: "chevron.left")?
                .withTintColor(tint, renderingMode: .alwaysOriginal)
            appearance.setBackIndicatorImage(chevron, transitionMaskImage: chevron)
            let navigationBar = UINavigationBar.appearance()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            return
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.Background.primary)
        appearance.shadowColor = .clear

        let chevron = UIImage(
            systemName: "chevron.left",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        )
        appearance.setBackIndicatorImage(chevron, transitionMaskImage: chevron)

        let backButton = UIBarButtonItemAppearance(style: .plain)
        backButton.normal.titleTextAttributes = [
            .font: UIFont.pretendard(weight: .medium, size: 16),
            .foregroundColor: tint
        ]
        appearance.backButtonAppearance = backButton

        // 툴바 글씨 버튼(만들기, 체크리스트 변경, 취소 등)도 Pretendard로 맞춘다
        let barButton = UIBarButtonItemAppearance(style: .plain)
        barButton.normal.titleTextAttributes = backButton.normal.titleTextAttributes
        appearance.buttonAppearance = barButton
        appearance.doneButtonAppearance = barButton

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
}
