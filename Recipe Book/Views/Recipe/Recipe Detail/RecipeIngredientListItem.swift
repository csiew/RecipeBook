//
//  RecipeIngredientListItem.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeIngredientListItem: View {
    var ingredient: RecipeIngredient
    
    var body: some View {
        HStack {
            Text(ingredient.name)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing, 16)
            Spacer()
            Section {
                if ingredient.quantity != nil {
                    Text("\(ingredient.quantity!)")
                }
                if ingredient.unit != MeasurementUnit.none {
                    Text(ingredient.getUnit())
                }
            }
        }
    }
}

struct RecipeIngredientListItem_Previews: PreviewProvider {
    static var previews: some View {
        RecipeIngredientListItem(ingredient: sampleIngredient)
    }
}
