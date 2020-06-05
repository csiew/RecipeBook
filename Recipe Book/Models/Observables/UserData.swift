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
    
    func getRecipe(id: String) -> Recipe? {
        let result = recipes.filter { $0.id == id }
        if result.count == 0 {
            return nil
        }
        return result.first
    }
    
    func setRecipe(recipe: Recipe) {
        recipes.removeAll(where: { $0.id == recipe.id })
        recipes.append(recipe)
    }
}
