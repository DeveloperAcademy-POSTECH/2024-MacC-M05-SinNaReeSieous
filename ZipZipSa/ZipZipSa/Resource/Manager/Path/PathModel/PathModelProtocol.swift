//
//  PathModelProtocol.swift
//  ZipZipSa
//
//  Created by 조우현 on 11/30/24.
//

import SwiftUI

protocol PathModelProtocol: ObservableObject {
    var path: NavigationPath { get set }
    
    func push(_ screen: Screen)
    func pop()
    func popToRoot()
}
