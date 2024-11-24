//
//  UIFont+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import UIKit

extension UIFont {
    static func pretendard(weight: PretendardFontWeight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.name, size: size)!
    }
}
