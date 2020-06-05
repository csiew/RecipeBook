//
//  ArrayComparison.swift
//  Recipe Book
//
//  Created by Clarence Siew on 5/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

final class ArrayComparison {
    static func isMatchingString(array1: [String], array2: [String]) -> Bool {
        if array1.count == array2.count {
            let array1Sorted = array1.sorted(by: { $0 < $1 })
            let array2Sorted = array2.sorted(by: { $0 < $1 })
            
            for (index, item) in array1Sorted.enumerated() {
                if item != array2Sorted[index] {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    static func isMatchingIngredient(array1: [RecipeIngredient], array2: [RecipeIngredient]) -> Bool {
        if array1.count == array2.count {
            let array1Sorted = array1.sorted(by: { $0.id < $1.id })
            let array2Sorted = array2.sorted(by: { $0.id < $1.id })
            
            for (index, ingredient) in array1Sorted.enumerated() {
                if !ingredient.isMatching(ingredient: array2Sorted[index]) {
                    return false
                }
            }
            return true
        }
        return false
    }
}
