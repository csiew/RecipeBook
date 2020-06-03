//
//  UserSettings.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Combine
import SwiftUI

final class UserSettings: ObservableObject {
    // Modifiable settings
    @Published var listsAreGrouped: Bool = true
    @Published var theme: ColorScheme = Environment(\.colorScheme).wrappedValue
    @Published var chosenTheme: ColorSchemeSupplemental = .system
    @Published var fontFamily: Font? = Environment(\.font).wrappedValue
    @Published var chosenFontFamily: FontSchemeSupplemental = .SanFrancisco
    
    // States
    @Published var selectedTab: Int = 0
}

enum ColorSchemeSupplemental {
    case light, dark, system
}

class FontScheme {
    static func sanfran() -> Font? { return Font(UIFont.systemFont(ofSize: 17)) }
    static func publicsans() -> Font? { return Font(UIFont(name: "Public Sans", size: 17)!) }
    static func gelasio() -> Font? { return Font(UIFont(name: "Gelasio", size: 17)!) }
}

enum FontSchemeSupplemental {
    case SanFrancisco, PublicSans, Gelasio
}
