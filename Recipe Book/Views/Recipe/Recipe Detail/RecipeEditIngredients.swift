//
//  RecipeEditIngredients.swift
//  Recipe Book
//
//  Created by Clarence Siew on 8/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI
import Combine

class IngredientDraftBuffer: ObservableObject {
    @Published var index: Int = 0
    @Published var ingredient: RecipeIngredient?
    
    func reset() {
        self.index = 0
        self.ingredient = nil
    }
}

struct RecipeEditIngredients: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ingredientDraftBuffer = IngredientDraftBuffer()
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var editMode: EditMode
    @State var showAddIngredientModal: Bool = false
    @State var selectedItem: Int = 0
    
    var body: some View {
        Group {
            if self.recipeDataObserver.ingredients.count == 0 {
                Text("No ingredients for this recipe")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(0..<recipeDataObserver.ingredients.count, id: \.self) { index in
                        RecipeIngredientListItem(ingredient: self.recipeDataObserver.ingredients[index])
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture(perform: {
                                self.selectedItem = index
                                self.showAddIngredientModal = true
                            })
                    }
                    .onMove(perform: { (offsets, targetOffset) in
                        self.recipeDataObserver.ingredients.move(fromOffsets: offsets, toOffset: targetOffset)
                    })
                    .onDelete(perform: { offsets in
                        self.recipeDataObserver.ingredients.remove(atOffsets: offsets)
                    })
                    .sheet(isPresented: self.$showAddIngredientModal, content: {
                        AddRecipeIngredientModal(
                            ingredientDraftBuffer: self.ingredientDraftBuffer,
                            recipeDataObserver: self.recipeDataObserver,
                            description: self.recipeDataObserver.ingredients[self.selectedItem].name,
                            quantity: self.recipeDataObserver.ingredients[self.selectedItem].quantity ?? 0,
                            measurementUnit: self.recipeDataObserver.ingredients[self.selectedItem].unit,
                            index: self.selectedItem,
                            isExisting: true
                        )
                    })
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationBarTitle("Ingredients", displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack {
                    Button(action: { self.showAddIngredientModal = true }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showAddIngredientModal, content: {
                        AddRecipeIngredientModal(
                            ingredientDraftBuffer: self.ingredientDraftBuffer,
                            recipeDataObserver: self.recipeDataObserver,
                            description: "",
                            quantity: 0,
                            measurementUnit: .none
                        )
                    })
                }
        )
        .environment(\.editMode, self.$editMode)
    }
}

struct AddRecipeIngredientModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ingredientDraftBuffer: IngredientDraftBuffer
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @State var description: String
    @State var quantity: Int
    @State var measurementUnit: MeasurementUnit
    @State var index: Int = 0
    @State var isExisting: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name/Description", text: self.$description)
                HStack {
                    Text("Quantity")
                    Stepper("", value: self.$quantity, in: 0...9999)
                    Spacer()
                    TextField("", value: self.$quantity, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(self.quantity > 9999 ? Color(UIColor.systemRed) : Color.primary)
                        .padding(.all, 5)
                        .frame(maxWidth: 64)
                        .background(Color(UIColor.secondarySystemFill))
                        .cornerRadius(8)
                        .frame(alignment: .trailing)
                }
                Picker(selection: self.$measurementUnit, label: Text("Measurement unit")) {
                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                        Text(MeasurementUnitSupplemental.getLongDescription(unit: unit))
                    }
                }
            }
            .navigationBarTitle("Add Ingredient", displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
                    },
                trailing:
                    HStack {
                        Button(action: {
                            if self.isExisting == false {
                                self.addIngredient()
                            } else {
                                self.updateIngredient()
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done").bold()
                        }
                        .disabled(self.description.isEmpty && (Int(self.quantity) <= 999))
                    }
                )
        }
        .onDisappear(perform: {
            if self.ingredientDraftBuffer.ingredient != nil {
                self.recipeDataObserver.ingredients[self.index] = self.ingredientDraftBuffer.ingredient!
                self.ingredientDraftBuffer.reset()
            }
        })
    }
    
    func addIngredient() {
        self.recipeDataObserver.ingredients.append(RecipeIngredient(id: nil, name: self.description, quantity: self.quantity == 0 ? nil : self.quantity, unit: measurementUnit))
    }
    
    func updateIngredient() {
        let id = self.recipeDataObserver.ingredients[self.index].id
        self.ingredientDraftBuffer.ingredient = RecipeIngredient(id: id, name: self.description, quantity: self.quantity == 0 ? nil : self.quantity, unit: measurementUnit)
    }
}

struct RecipeEditIngredients_Previews: PreviewProvider {
    static var previews: some View {
        RecipeEditIngredients(recipeDataObserver: RecipeDataObserver(ingredients: recipe1.ingredients, directions: recipe1.directions), editMode: .constant(.active))
    }
}
