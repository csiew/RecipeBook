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
    
    // States
    @Published var selectedTab: Int = 0
}
