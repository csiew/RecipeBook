//
//  EditMode.swift
//  Recipe Book
//
//  Based on: https://stackoverflow.com/a/57812310
//
//  Created by Clarence Siew on 5/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Edit"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
