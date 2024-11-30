//
//  Array+.swift
//  ZipZipSa
//
//  Created by 조우현 on 12/1/24.
//

import Foundation
import MapKit

extension Array where Element == MKMapItem {
    func uniqued() -> [MKMapItem] {
        var seen = Set<String>()
        return self.filter { item in
            let identifier = "\(item.name ?? "")_\(item.placemark.coordinate.latitude)_\(item.placemark.coordinate.longitude)"
            if seen.contains(identifier) {
                return false
            } else {
                seen.insert(identifier)
                return true
            }
        }
    }
}
