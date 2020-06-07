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
    @Published var recipes: Dictionary<String, Recipe> = UserData.indexRecipes(recipes: sampleRecipes)
    
    func getRecipe(id: String) -> Recipe? {
        return recipes[id]
    }
    
    func getRecipes() -> [Recipe] {
        return recipes.compactMap({ $0.value })
    }
    
    func setRecipe(recipe: Recipe) {
        recipes[recipe.id] = recipe
    }
    
    func removeRecipe(id: String) {
        if recipes.keys.contains(where: { $0 == id }) {
            recipes.removeValue(forKey: id)
        }
    }
    
    static func indexRecipes(recipes: [Recipe]) -> Dictionary<String, Recipe> {
        var recipeIndex: Dictionary<String, Recipe> = Dictionary<String, Recipe>()
        recipes.forEach { recipe in
            recipeIndex[recipe.id] = recipe
        }
        return recipeIndex
    }
}
