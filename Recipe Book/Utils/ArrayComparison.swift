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
    
    static func isMatchingIngredient(array1: [Any], array2: [Any]) -> Bool {
        if array1.count == array2.count {
            let array1Sorted = array1.sorted(by: { ($0 as! Ingredient).name < ($1 as! Ingredient).name })
            let array2Sorted = array2.sorted(by: { ($0 as! Ingredient).name < ($1 as! Ingredient).name })
            
            for (index, item) in array1Sorted.enumerated() {
                if (item as! Ingredient) != (array2Sorted[index] as! Ingredient) {
                    return false
                }
            }
            return true
        }
        return false
    }
}
