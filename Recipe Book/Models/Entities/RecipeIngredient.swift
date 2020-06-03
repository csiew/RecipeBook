//
//  RecipeIngredient.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

enum MeasurementUnit {
    case none
    case mililitre, litre
    case miligram, gram, kilogram
    case teaspoon, tablespoon, ladle
    case cup, mug, bowl, sauceplatter
    case piece
    case horse  // so hungry that I could eat a horse
}

struct RecipeIngredient: Identifiable {
    var id: String
    var name: String
    var quantity: Int?
    var unit: MeasurementUnit
    
    init(id: String? = UUID().uuidString, name: String, quantity: Int? = nil, unit: MeasurementUnit? = MeasurementUnit.none) {
        self.id = id!
        self.name = name
        self.quantity = quantity
        self.unit = unit!
    }
}
