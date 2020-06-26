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
            for (index, item) in array1.enumerated() {
                if item != array2[index] {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    static func isMatchingStringContent(array1: [String], array2: [String]) -> Bool {
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
    
    static func isMatchingIngredient(array1: [IngredientDraft], array2: [Ingredient]) -> Bool {
        if array1.count == array2.count {
            let array1Sorted = array1.sorted(by: { $0.name < $1.name })
            let array2Sorted = array2.sorted(by: { $0.name < $1.name })
            
            for (index, draftItem) in array1Sorted.enumerated() {
                if ((draftItem.id != array2Sorted[index].id) || (draftItem.name != array2Sorted[index].name) || (draftItem.quantity != array2Sorted[index].quantity) || (draftItem.unit != MeasurementUnit.init(rawValue: array2Sorted[index].unit))) {
                    return false
                }
            }
            return true
        }
        return false
    }
}
