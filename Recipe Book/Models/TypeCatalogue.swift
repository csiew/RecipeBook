//
//  TypeCatalogue.swift
//  Recipe Book
//
//  Created by Clarence Siew on 11/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

enum TypeCatalogue: String, CaseIterable {
    case Recipe
    case Ingredient
    
    var rawValue: String {
        switch self {
            case .Recipe: return "Recipe"
            case .Ingredient: return "Ingredient"
        }
    }
}
