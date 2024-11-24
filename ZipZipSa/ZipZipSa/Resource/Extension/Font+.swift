//
//  Font+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import SwiftUI

extension Font {
    static func pretendard(weight: PretendardFontWeight, size: CGFloat) -> Font {
        return Font.custom(weight.name, size: size)
    }
}
