//
//  RecipeIngredient.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

struct RecipeIngredient: Hashable, Identifiable {
    var id: String
    var name: String
    var quantity: Int
    var unit: MeasurementUnit
    var recipe: Recipe?
    
    init(id: String? = nil, name: String, quantity: Int? = nil, unit: MeasurementUnit? = MeasurementUnit.none, recipe: Recipe?) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.quantity = quantity ?? 0
        self.unit = unit!
        self.recipe = recipe
    }
    
    func getUnit() -> String {
        return MeasurementUnitSupplemental.getShortDescription(unit: self.unit)
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
