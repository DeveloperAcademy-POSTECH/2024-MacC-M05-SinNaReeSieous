//
//  ZZSCloseButton.swift
//  ZipZipSa
//

import SwiftUI

/// 모달(fullScreenCover) 첫 화면의 툴바 닫기 버튼.
/// iOS 26은 시스템 닫기(유리 X), iOS 18은 기존 디자인의 "X 닫기".
struct ZZSCloseButton: View {
    let action: () -> Void

    var body: some View {
        if #available(iOS 26, *) {
            Button(role: .close, action: action)
        } else {
            Button(action: action) {
                ZZSToolbarLabel(title: ZipLiteral.ChecklistTemplate.close, systemImage: "xmark")
            }
        }
    }
}

/// 아이콘이 있는 툴바 버튼.
///
/// iOS 26은 HIG 권장대로 아이콘만 보이는 시스템 버튼(유리)을 쓴다. 이름은 접근성 라벨로 남는다.
/// iOS 18은 시스템 툴바가 아이콘만 남기므로, 기존 디자인의 "아이콘 + 글씨"를 직접 그린다.
struct ZZSToolbarButton: View {
    let title: String
    let systemImage: String
    /// iOS 18 라벨의 아이콘 글꼴. 꺾쇠·X·+는 iconTitle1(20), 그 밖의 심볼은 Figma에 맞춰 지정한다.
    var iconFont: ZZSFontSet = .iconTitle1
    let action: () -> Void

    var body: some View {
        if #available(iOS 26, *) {
            Button(title, systemImage: systemImage, action: action)
        } else {
            Button(action: action) {
                ZZSToolbarLabel(title: title, systemImage: systemImage, iconFont: iconFont)
            }
        }
    }
}

/// iOS 18 툴바 버튼의 "아이콘 + 글씨" 라벨. 앱 UI 규칙(아이콘 iconTitle1, 글씨 bodyRegular, Button.tertiary)을 따른다.
struct ZZSToolbarLabel: View {
    let title: String
    let systemImage: String
    var iconFont: ZZSFontSet = .iconTitle1

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .applyZZSFont(zzsFontSet: iconFont)
            Text(title)
                .applyZZSFont(zzsFontSet: .bodyRegular)
                .fixedSize()
        }
        .foregroundStyle(Color.Button.tertiary)
    }
}
