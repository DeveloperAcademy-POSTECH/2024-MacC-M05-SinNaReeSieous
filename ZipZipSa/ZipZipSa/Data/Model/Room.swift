//
//  Room.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/11/24.
//

import UIKit
import SwiftData

@Model
final class Room {
    @Attribute(.unique) var id: UUID
    var deposit: Int
    var rentalFee: Int
    
    init(deposit: Int, rentalFee: Int) {
        self.id = UUID()
        self.deposit = deposit
        self.rentalFee = rentalFee
    }
}
