//
//  PathModel.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import SwiftUI

@Observable
final class PathModel: PathModelProtocol {
    
    var path: NavigationPath = NavigationPath()
    var sheetPath: NavigationPath = NavigationPath()
    var sheet: Sheet?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pushSheet(_ sheet: Sheet) {
        sheetPath.append(sheet)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast()
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
}
