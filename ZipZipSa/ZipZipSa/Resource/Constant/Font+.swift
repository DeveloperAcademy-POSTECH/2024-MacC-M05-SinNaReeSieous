//
//  Font+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import SwiftUI

enum PretendardFontWeight: String, CaseIterable {
    case thin
    case ultraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    
    var name: String {
        switch self {
        case .thin: return "PretendardVariable-Thin"
        case .ultraLight: return "PretendardVariable-ExtraLight"
        case .light: return "PretendardVariable-Light"
        case .regular: return "PretendardVariable-Regular"
        case .medium: return "PretendardVariable-Medium"
        case .semiBold: return "PretendardVariable-SemiBold"
        case .bold: return "PretendardVariable-Bold"
        case .extraBold: return "PretendardVariable-ExtraBold"
        case .black: return "PretendardVariable-Black"
        }
    }
}

extension Font {
    static func pretendard(weight: PretendardFontWeight, size: CGFloat) -> Font {
        return Font.custom(weight.name, size: size)
    }
    
    enum ZZS {
        static let largeTitle = pretendard(weight: .bold, size: 28)
        
        static let title1 = pretendard(weight: .bold, size: 24)
        static let title2 = pretendard(weight: .bold, size: 20)
        
        static let headline = pretendard(weight: .bold, size: 16)
        
        static let bodyBold = pretendard(weight: .semiBold, size: 16)
        static let bodyRegular = pretendard(weight: .medium, size: 16)
        
        static let subheadlineBold = pretendard(weight: .semiBold, size: 14)
        static let subheadlineRegular = pretendard(weight: .medium, size: 14)
        
        static let footnote = pretendard(weight: .medium, size: 13)
        
        static let caption1Bold = pretendard(weight: .bold, size: 12)
        static let caption1Regular = pretendard(weight: .medium, size: 12)
        static let caption2 = pretendard(weight: .medium, size: 10)
        
        static let iconLargeTitle = Font.system(size: 24, weight: .regular)
        static let iconTitle1 = Font.system(size: 20, weight: .regular)
        static let iconBody = Font.system(size: 16, weight: .regular)
        static let iconSubheadline = Font.system(size: 13, weight: .regular)
    }
    
}


