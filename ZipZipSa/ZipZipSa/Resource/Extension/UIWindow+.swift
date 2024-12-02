//
//  UIWindow.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import UIKit

extension UIWindow {
    func topMostViewController() -> UIViewController? {
        var topController = self.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}
