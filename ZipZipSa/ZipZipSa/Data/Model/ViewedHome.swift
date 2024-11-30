//
//  Home.swift
//  ZipZipSa
//
//  Created by JIN LEE on 11/28/24.
//

import UIKit

struct ViewedHome: Identifiable {
    let id: UUID
    let image: UIImage?
    let title: String
    let address: String?
    let rentType: String?
    
    init(id: UUID = UUID(), image: UIImage?, title: String, address: String?, rentType: String?) {
        self.id = id
        self.image = image
        self.title = title
        self.address = address
        self.rentType = rentType
    }
}

