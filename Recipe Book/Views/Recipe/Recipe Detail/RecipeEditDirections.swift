//
//  RecipeEditDirections.swift
//  Recipe Book
//
//  Created by Clarence Siew on 8/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeEditDirections: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var editMode: EditMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<recipeDataObserver.directions.count, id: \.self) { index in
                    RecipeDirectionListItem(index: index, direction: self.recipeDataObserver.directions[index])
                        .padding(.all, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(index % 2 == 0 ? Color(UIColor.lightBlue) : Color(UIColor.secondarySystemFill))
                        .cornerRadius(8)
                }
                .onMove(perform: { (offsets, targetOffset) in
                    self.recipeDataObserver.directions.move(fromOffsets: offsets, toOffset: targetOffset)
                })
                .onDelete(perform: { offsets in
                    self.recipeDataObserver.directions.remove(atOffsets: offsets)
                })
            }
            .navigationBarTitle("Directions", displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button("Close", action: { self.presentationMode.wrappedValue.dismiss() })
                    },
                trailing:
                    HStack {
                        Button(action: { print("Add direction button pressed") }) {
                            Image(systemName: "plus")
                        }
                    }
            )
            .environment(\.editMode, self.$editMode)
        }
    }
}

struct RecipeEditDirections_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditDirections(recipeDataObserver: RecipeDataObserver(ingredients: recipe1.ingredients, directions: recipe1.directions), editMode: .constant(.active))
    }
}
