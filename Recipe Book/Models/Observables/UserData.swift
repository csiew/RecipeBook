//
//  UserData.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var recipes: [Recipe] = sampleRecipes
}
