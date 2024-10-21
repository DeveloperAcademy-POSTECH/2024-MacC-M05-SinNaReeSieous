//
//  Font+.swift
//  Eggong
//
//  Created by 조우현 on 10/17/24.
//

import SwiftUI

enum SDGothicNeoFontWeight: String, CaseIterable {
    case thin
    case ultraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case heavy
    
    var name: String {
        switch self {
        case .thin: return "AppleSDGothicNeo-Thin"
        case .ultraLight: return "AppleSDGothicNeo-UltraLight"
        case .light: return "AppleSDGothicNeo-Light"
        case .regular: return "AppleSDGothicNeo-Regular"
        case .medium: return "AppleSDGothicNeo-Medium"
        case .semiBold: return "AppleSDGothicNeo-Semibold"
        case .bold: return "AppleSDGothicNeo-Bold"
        case .extraBold: return "AppleSDGothicNeoEB00"
        case .heavy: return "AppleSDGothicNeoH00"
        }
    }
}

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
    static func appleSDGothicNeo(size: CGFloat, weight: SDGothicNeoFontWeight) -> Font {
        return Font.custom(weight.name, size: size)
    }
    
    static func pretendard(size: CGFloat, weight: PretendardFontWeight) -> Font {
        return Font.custom(weight.name, size: size)
    }
    
    static func uiFont(size: CGFloat, weight: SDGothicNeoFontWeight) -> UIFont {
        return UIFont(name: weight.name, size: size)!
    }
}


