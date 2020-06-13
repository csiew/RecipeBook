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
    @Published var ingredient: Ingredient?
    
    func reset() {
        self.index = 0
        self.ingredient = nil
    }
}

struct RecipeEditIngredients: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var ingredientDraftBuffer = IngredientDraftBuffer()
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var editMode: EditMode
    @State var recipe: Recipe
    @State var ingredient: Ingredient? = nil
    @State var showAddIngredientModal: Bool = false
    @State var selectedItem: Int? = nil
    
    var body: some View {
        Group {
            if self.recipeDataObserver.ingredients.count == 0 {
                Text("No ingredients for this recipe")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(0..<self.recipeDataObserver.ingredients.count, id: \.self) { index in
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
                            recipe: self.$recipe,
                            selectedItem: self.selectedItem
                        )
                        .environmentObject(self.objectManager)
                        .onDisappear(perform: {
                            self.selectedItem = nil
                        })
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
                    }
                }
        )
        .environment(\.editMode, self.$editMode)
        .onAppear(perform: {
            print(self.recipeDataObserver.ingredients)
        })
    }
}

struct AddRecipeIngredientModal: View {
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var ingredientDraftBuffer: IngredientDraftBuffer
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var recipe: Recipe
    @State var description: String = ""
    @State var quantity: Int = 0
    @State var measurementUnit: MeasurementUnit = MeasurementUnit.none
    @State var selectedItem: Int? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name/Description", text: self.$description)
                HStack {
                    Text("Quantity")
                    Stepper("", value: self.$quantity, in: 0...999)
                    Spacer()
                    TextField("", value: self.$quantity, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(self.quantity > 999 ? Color(UIColor.systemRed) : Color.primary)
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
                            if self.selectedItem == nil {
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
        .onAppear(perform: {
            if self.selectedItem != nil {
                self.ingredientDraftBuffer.ingredient = self.recipeDataObserver.ingredients[self.selectedItem!]
                self.description = self.recipeDataObserver.ingredients[self.selectedItem!].name
                self.quantity = self.recipeDataObserver.ingredients[self.selectedItem!].quantity
                self.measurementUnit = MeasurementUnit(rawValue: self.recipeDataObserver.ingredients[self.selectedItem!].unit) ?? MeasurementUnit.none
            }
        })
        .onDisappear(perform: {
            if self.selectedItem != nil {
                self.ingredientDraftBuffer.reset()
            }
        })
    }
    
    func addIngredient() {
        let ingredient = Ingredient(permanent: true, insertIntoManagedObjectContext: self.objectManager.managedObjectContext, id: nil, name: self.description, quantity: self.quantity, unit: MeasurementUnit(rawValue: measurementUnit.rawValue).map { $0.rawValue }!, recipe: self.recipe)
        self.recipe.addToIngredients(ingredient)
        self.recipeDataObserver.ingredients.append(ingredient)
        self.objectManager.save()
    }
    
    func updateIngredient() {
        if self.selectedItem != nil {
            self.recipe.updateIngredient(self.ingredientDraftBuffer.ingredient!.id, name: self.description, quantity: self.quantity, unit: MeasurementUnit(rawValue: measurementUnit.rawValue).map { $0.rawValue }!)
            self.recipeDataObserver.ingredients[self.selectedItem!].name = self.description
            self.recipeDataObserver.ingredients[self.selectedItem!].quantity = self.quantity
            self.recipeDataObserver.ingredients[self.selectedItem!].unit = self.measurementUnit.rawValue
            self.objectManager.save()
        }
    }
}
