//
//  PretendardFontWeight.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import Foundation

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
