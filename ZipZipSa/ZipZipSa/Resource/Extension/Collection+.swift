//
//  Collection+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/27/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
