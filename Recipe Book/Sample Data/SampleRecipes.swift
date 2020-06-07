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
var recipe4 = Recipe(
    name: "Les Pets de Soeurs (The Farts of Nuns)",
    description: """
    These feather-light deep-fried beignets most likely got their nickname "pets de nonne" (literally "nun’s farts") from a slight bastardization of the earlier term "paix-de-nonne" (“nun’s peace”). There are plenty of other theories, but being related to certain members of my French family that when given the proper dosage of pastis have a penchant for bending innocent words into far more vulgar ones at the drop of a hat. Give these delicious little puffs a try, despite the crude name they taste simply fantastic.\n\nLet’s examine the Choux paste, pâte à choux in French, that is used to make the ‘Nun’s Farts’. Choux paste is a simple French dough that usually contains only four ingredients: milk/water, butter, flour, and eggs. The dough itself can easily be made in 5 to 10 minutes then baked or fried. It is interesting to note that the reason choux paste puffs is because of the high moisture content. As the dough cooks, steam is produced and the dough begins to puff. It stays puffed by baking the dough a bit longer until it starts to dry. Choux paste can also make profiteroles, eclairs, gougeres, and even can be mixed with mashed potatoes to make pommes Dauphine or potato puffs. It takes barely any more time to make a single batch as it does a double batch. Try making a fun dessert with half then mix the other half with potatoes. If you make a double batch of mashed potatoes one day you could make a simple shepherd’s pie the next. Versatility is the key.
    """,
    source: "https://pistouandpastis.com/2020/04/nuns-farts/",
    cuisineId: "french",
    genreId: "frying",
    ingredients: [
        RecipeIngredient(name: "Milk", quantity: 1, unit: .cup),
        RecipeIngredient(name: "Unsalted butter", quantity: 8, unit: .tablespoon),
        RecipeIngredient(name: "Salt", quantity: 1, unit: .pinch),
        RecipeIngredient(name: "Granulated sugar", quantity: 1, unit: .tablespoon),
        RecipeIngredient(name: "All-purpose flour", quantity: 1, unit: .cup),
        RecipeIngredient(name: "Large eggs", quantity: 4, unit: MeasurementUnit.none),
        RecipeIngredient(name: "Dark rum", quantity: 1, unit: .tablespoon),
        RecipeIngredient(name: "Orange zest", quantity: 1, unit: MeasurementUnit.none),
        RecipeIngredient(name: "Vegetable oil", quantity: 2, unit: .quarts),
        RecipeIngredient(name: "Granulated sugar (for rolling cooked beignet in)", quantity: 1, unit: .cup)
    ],
    directions: [
        "In a large stainless steel saucepan over medium-high heat, combine the milk, butter, salt, and sugar. Bring to a rapid boil, stirring to combine as the butter melts. Reduce the heat to medium and, using a wooden spoon, stir in the flour all at once. Cook, stirring constantly, until the dough dries out slightly, about 1 minute. This is important—excess moisture will cause your puffs to collapse. Remove the pan from the heat and let the dough cool for 5 minutes.",
        "Stir in the eggs, one at a time, until fully incorporated before adding the next. You can mix in the eggs with a mixer, food processor, or a wooden spoon to get a workout. Stir in the rum and orange zest.",
        "It is best if you can let the dough rest overnight, but if you are impatient you can cook immediately. In a large, heavy saucepan, Dutch oven, or deep fryer, heat the oil to 350°F. Working in batches, drop tablespoons of dough into the hot oil and cook until golden brown, about 3 - 5 minutes. Remove the beignets using a wire skimmer and drain on paper towels. Roll in granulated sugar and serve still warm."
    ]
)

var sampleRecipes: [Recipe] = [recipe1, recipe2, recipe3, recipe4]

var sampleIngredient = RecipeIngredient(name: "Brown Sugar", quantity: 1, unit: .tablespoon)
