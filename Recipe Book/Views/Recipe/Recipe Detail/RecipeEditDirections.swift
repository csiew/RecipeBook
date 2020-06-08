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
    @State var showAddDirectionModal: Bool = false
    
    var body: some View {
        List {
            ForEach(0..<recipeDataObserver.directions.count, id: \.self) { index in
                RecipeDirectionListItem(index: index, direction: self.recipeDataObserver.directions[index])
                    .padding(.all, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            trailing:
                HStack {
                    Button(action: { self.showAddDirectionModal = true }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showAddDirectionModal, content: {
                        AddRecipeDirectionModal(recipeDataObserver: self.recipeDataObserver)
                    })
                }
        )
        .environment(\.editMode, self.$editMode)
    }
}

struct AddRecipeDirectionModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @State var directionText: String = ""
    
    var body: some View {
        NavigationView {
            MultilineTextField(text: self.$directionText, isFirstResponder: true)
                .font(.body)
                .padding(.all, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarTitle("Add Direction", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        HStack {
                            Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
                        },
                    trailing:
                        HStack {
                            Button(action: {
                                self.addDirection(text: self.directionText)
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Done").bold()
                            }
                            .disabled(self.directionText.isEmpty)
                        }
                    )
        }
    }
    
    func addDirection(text: String) {
        self.recipeDataObserver.directions.append(text)
    }
}

struct RecipeEditDirections_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditDirections(recipeDataObserver: RecipeDataObserver(ingredients: recipe1.ingredients, directions: recipe1.directions), editMode: .constant(.active))
    }
}
