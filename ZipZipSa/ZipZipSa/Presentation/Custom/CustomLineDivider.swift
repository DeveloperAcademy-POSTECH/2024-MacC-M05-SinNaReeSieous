//
//  CustomLineDivider.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/21/24.
//

import SwiftUI

// 점선 디바이더
struct Line: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
