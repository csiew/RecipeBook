//
//  Recipe.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

struct Recipe: Identifiable {
    var id: String
    var name: String
    var description: String
    var source: String
    var ingredients: [RecipeIngredient]
    var directions: [String] = Array()
    var cuisineId: String?
    var genreId: String?
    
    init(id: String? = UUID().uuidString, name: String? = "", description: String? = "", source: String? = "", cuisineId: String? = nil, genreId: String? = nil, ingredients: [RecipeIngredient]? = Array(), directions: [String]? = Array()) {
        self.id = id!
        self.name = name!
        self.description = description!
        self.source = source!
        self.cuisineId = cuisineId
        self.genreId = genreId
        self.ingredients = ingredients!
        self.directions = directions!
    }
}
