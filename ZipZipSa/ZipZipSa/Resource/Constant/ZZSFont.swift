//
//  ZZSFont.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import SwiftUI

enum ZZSFontSet {
    case largeTitle
    case title1
    case title2
    case headline
    case bodyBold
    case bodyRegular
    case subheadlineBold
    case subheadlineRegular
    case footnote
    case caption1Bold
    case caption1Regular
    case caption2
    case iconLargeTitle
    case iconTitle1
    case iconBody
    case iconSubheadline
    
    var font: Font {
        switch self {
        case .largeTitle: return Font.pretendard(weight: .bold, size: 28)
        case .title1: return Font.pretendard(weight: .bold, size: 24)
        case .title2: return Font.pretendard(weight: .bold, size: 20)
        case .headline: return Font.pretendard(weight: .bold, size: 16)
        case .bodyBold: return Font.pretendard(weight: .semiBold, size: 16)
        case .bodyRegular: return Font.pretendard(weight: .medium, size: 16)
        case .subheadlineBold: return Font.pretendard(weight: .semiBold, size: 14)
        case .subheadlineRegular: return Font.pretendard(weight: .medium, size: 14)
        case .footnote: return Font.pretendard(weight: .medium, size: 13)
        case .caption1Bold: return Font.pretendard(weight: .bold, size: 12)
        case .caption1Regular: return Font.pretendard(weight: .medium, size: 12)
        case .caption2: return Font.pretendard(weight: .medium, size: 10)
        case .iconLargeTitle: return Font.system(size: 24, weight: .regular)
        case .iconTitle1: return Font.system(size: 20, weight: .regular)
        case .iconBody: return Font.system(size: 16, weight: .regular)
        case .iconSubheadline: return Font.system(size: 13, weight: .regular)
        }
    }
    
    var uiFont: UIFont {
        switch self {
        case .largeTitle: return UIFont.pretendard(weight: .bold, size: 28)
        case .title1: return UIFont.pretendard(weight: .bold, size: 24)
        case .title2: return UIFont.pretendard(weight: .bold, size: 20)
        case .headline: return UIFont.pretendard(weight: .bold, size: 16)
        case .bodyBold: return UIFont.pretendard(weight: .semiBold, size: 16)
        case .bodyRegular: return UIFont.pretendard(weight: .medium, size: 16)
        case .subheadlineBold: return UIFont.pretendard(weight: .semiBold, size: 14)
        case .subheadlineRegular: return UIFont.pretendard(weight: .medium, size: 14)
        case .footnote: return UIFont.pretendard(weight: .medium, size: 13)
        case .caption1Bold: return UIFont.pretendard(weight: .bold, size: 12)
        case .caption1Regular: return UIFont.pretendard(weight: .medium, size: 12)
        case .caption2: return UIFont.pretendard(weight: .medium, size: 10)
        case .iconLargeTitle: return UIFont.systemFont(ofSize: 24, weight: .regular)
        case .iconTitle1: return UIFont.systemFont(ofSize: 20, weight: .regular)
        case .iconBody: return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .iconSubheadline: return UIFont.systemFont(ofSize: 13, weight: .regular)
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .largeTitle: return 32
        case .title1: return 28
        case .title2: return 24
        case .headline: return 19
        case .bodyBold: return 24
        case .bodyRegular: return 24
        case .subheadlineBold: return 20
        case .subheadlineRegular: return 20
        case .footnote: return 17
        case .caption1Bold: return 14
        case .caption1Regular: return 14
        case .caption2: return 13
        case .iconLargeTitle: return 29
        case .iconTitle1: return 24
        case .iconBody: return 19
        case .iconSubheadline: return 16
        }
    }
}


struct zzsFigmaFontModifier: ViewModifier {
    let zzsFontSet: ZZSFontSet
    
    private var additionalLineHeight: CGFloat {
        zzsFontSet.lineHeight - zzsFontSet.uiFont.lineHeight
    }
    
    private var additionalPadding: CGFloat {
        (zzsFontSet.lineHeight - zzsFontSet.uiFont.lineHeight)/2
    }
    
    func body(content: Content) -> some View {
        content
            .font(zzsFontSet.font)
            .lineSpacing(additionalLineHeight)
            .padding(.vertical, additionalPadding)
    }
}
