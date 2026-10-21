//
//  UINavigationController+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import SwiftUI

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        // iOS 26부터는 화면 어디서든 밀어서 뒤로 가는 제스처가 따로 있다
        if #available(iOS 26, *) {
            interactiveContentPopGestureRecognizer?.isEnabled = false
        }
    }

    /// 밀어서 뒤로 가기는 막는다.
    /// 체크리스트 작성 중처럼 실수로 밀면 입력이 날아가는 화면이 있어, 뒤로 버튼으로만 이동한다.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
