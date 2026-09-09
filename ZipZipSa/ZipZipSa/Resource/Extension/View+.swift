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
        let renderer = UIGraphicsImageRenderer(size: size)

        guard let view = controller.view else {
            return renderer.image { _ in }
        }

        view.bounds = CGRect(origin: .zero, size: size)
        view.backgroundColor = UIColor(Color.Background.primary)

        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
    
    func applyZZSFont(zzsFontSet: ZZSFontSet) -> some View {
        self.modifier(zzsFigmaFontModifier(zzsFontSet: zzsFontSet))
    }
    
    func dismissKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
