//
//  RecipeIngredientListItem.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeIngredientListItem: View {
    var ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing, 16)
            Spacer()
            Section {
                if ingredient.quantity > 0 {
                    Text(String(ingredient.quantity))
                }
                if ingredient.unit != MeasurementUnit.none.rawValue {
                    Text(MeasurementUnitSupplemental.getLongDescription(unit: MeasurementUnit(rawValue: ingredient.unit)!))
                }
            }
        }
    }
}

struct RecipeIngredientDraftListItem: View {
    var ingredient: IngredientDraft
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing, 16)
            Spacer()
            Section {
                if ingredient.quantity > 0 {
                    Text(String(ingredient.quantity))
                }
                if ingredient.unit != MeasurementUnit.none {
                    Text(ingredient.unit.rawValue)
                }
            }
        }
    }
}
