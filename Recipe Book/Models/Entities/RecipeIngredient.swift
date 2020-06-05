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
    
    func getUnit() -> String {
        switch self.unit {
        case .none: return ""
        case .mililitre: return "ml"
        case .litre: return "l"
        case .miligram: return "mg"
        case .gram: return "g"
        case .kilogram: return "kg"
        case .teaspoon: return "tsp"
        case .tablespoon: return "tbsp"
        case .ladle: return "ladle"
        case .cup: return "cup"
        case .mug: return "mug"
        case .bowl: return "bowl"
        case .sauceplatter: return "sauceplatter"
        case .piece: return "piece"
        case .horse: return "neigh"
        }
    }
    
    func isMatching(ingredient: RecipeIngredient) -> Bool {
        if
            self.id == ingredient.id &&
            self.name == ingredient.name &&
            self.quantity == ingredient.quantity &&
            self.unit == ingredient.unit
        {
            return true
        }
        return false
    }
}
