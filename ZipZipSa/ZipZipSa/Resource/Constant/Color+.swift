//
//  Color+.swift
//  ZipZipSa
//
//  Created by YunhakLee on 11/24/24.
//

import SwiftUI

extension Color {
    enum Background {
        static let primary = Color(.zzsWarmGray10)
        static let secondary = Color(.zzsWarmGray20)
        static let enable = Color(.zzsWhite)
        static let active = Color(.zzsYellow20)
        static let disabled = Color(.zzsWhite.opacity(0.05))
    }
    
    enum Layer {
        static let first = Color(.zzsWhite.opacity(0.8))
        static let second = Color(.zzsWarmGray20)
    }
    
    enum Text {
        static let primary = Color(.zzsBlack)
        static let secondary = Color(.zzsBlue50)
        static let tertiary = Color(.zzsWarmGray60)
        static let placeholder = Color(.zzsWarmGray30)
        static let onColorPrimary = Color(.zzsWhite)
        static let onColorSecondary = Color(.zzsWarmGray10)
        static let onColorDisabled = Color(.zzsWarmGray40)
        static let error = Color(.zzsRed50)
        static let disabled = Color(.zzsWarmGray40)
    }
    
    enum Icon {
        static let primary = Color(.zzsWarmGray90)
        static let secondary = Color(.zzsBlue50)
        static let tertiary = Color(.zzsWarmGray50)
        static let onColor = Color(.zzsWhite)
        static let onColorDisabled = Color(.zzsWarmGray20)
        static let disabled = Color(.zzsWarmGray40)
    }
    
    enum Button {
        static let primaryBlue = Color(.zzsBlue20)
        static let secondaryYellow = Color(.zzsYellow20)
        static let secondaryBlue = Color(.zzsBlue10)
        static let tertiary = Color(.zzsWarmGray50)
        static let enable = Color(.zzsWhite)
        static let disabled = Color(.zzsWarmGray20)
        static let positive = Color(.zzsBlue20)
        static let neutral = Color(.zzsYellow20)
        static let negative = Color(.zzsRed20)
    }
    
    enum Tag {
        static let backgroundWhite = Color(.zzsWarmGray10.opacity(0.9))
        static let colorWhite = Color(.zzsWarmGray90)
        static let backgroundGray = Color(.zzsWarmGray70)
        static let colorGray = Color(.zzsWarmGray10)
    }
    
    enum ChecklistTag {
        static let backgroundGray = Color(.zzsWarmGray20)
        static let colorGray = Color(.zzsWarmGray90)
        static let backgroundYellow = Color(.zzsYellow20)
        static let colorYellow = Color(.zzsBlack)
    }
    
    enum Additional {
        static let seperator = Color(.zzsWarmGray30)
    }
}
