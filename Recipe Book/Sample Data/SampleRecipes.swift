//
//  SampleRecipes.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

var recipe1 = Recipe(
    name: "Baked Chicken",
    description: "An easy oven-baked chicken recipe with a simple spice-rub.",
    source: "Somewhere online",
    genreId: "baking",
    ingredients: [
        RecipeIngredient(name: "Brown Sugar", quantity: 1, unit: .tablespoon),
        RecipeIngredient(name: "Garlic Powder", quantity: 1, unit: .teaspoon),
        RecipeIngredient(name: "Paprika", quantity: 1, unit: .teaspoon),
        RecipeIngredient(name: "Salt", quantity: 1, unit: .teaspoon),
        RecipeIngredient(name: "Black Pepper", quantity: 1, unit: .teaspoon),
        RecipeIngredient(name: "Olive Oil", unit: MeasurementUnit.none),
        RecipeIngredient(name: "Boneless, skinless chicken breast", quantity: 2, unit: .piece),
        RecipeIngredient(name: "Lemon", quantity: 1, unit: .piece),
        RecipeIngredient(name: "Chopped Parsley", unit: MeasurementUnit.none)
    ],
    directions: [
        "Brine chicken in bowl/tub of salted warm water for 10 minutes. Then remove and cut into smaller pieces (2 pieces from large breast cut).",
        "Preheat oven to 190ºC.",
        "In a small bowl, combine brown sugar, garlic powder, paprika, salt, and pepper.",
        "Drizzle oil all over chicken and generously coat with seasoning mixture, shaking off excess.",
        "Scatter lemon slices in baking dish then place chicken on top.",
        "Bake until chicken is cooked through, or reads an internal temperature of 165º, about 25 minutes.",
        "Cover chicken loosely with foil and let rest for at least 5 minutes. Garnish with parsley, if using."
    ]
)
var recipe2 = Recipe(name: "Potato Wedges", genreId: "baking")
var recipe3 = Recipe(name: "Spaghetti Carbonara", genreId: "boiling")

var sampleRecipes: [Recipe] = [recipe1, recipe2, recipe3]

var sampleIngredient = RecipeIngredient(name: "Brown Sugar", quantity: 1, unit: .tablespoon)
