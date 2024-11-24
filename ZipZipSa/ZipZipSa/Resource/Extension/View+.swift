//
//  View+.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/20/24.
//

import SwiftUI

// ResultCardView를 이미지로 변환하여 저장 및 공유하기 위한 View Extension
extension View {
    func asUIImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .white
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
    
    func applyZZSFont(zzsFontSet: ZZSFontSet) -> some View {
        self.modifier(zzsFigmaFontModifier(zzsFontSet: zzsFontSet))
    }
}
