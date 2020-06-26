//
//  RecipeEditIngredients.swift
//  Recipe Book
//
//  Created by Clarence Siew on 8/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI
import Combine

struct RecipeEditIngredients: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @State var recipe: Recipe
    @State var ingredient: Ingredient? = nil
    @State var showAddIngredientModal: Bool = false
    @State var selectedItem: Int? = nil
    @State var editMode: EditMode = .active
    
    var body: some View {
        Group {
            if self.recipeDataObserver.draftIngredients.count == 0 {
                Text("No ingredients for this recipe")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(0..<self.recipeDataObserver.draftIngredients.count, id: \.self) { index in
                        RecipeIngredientDraftListItem(ingredient: self.recipeDataObserver.draftIngredients[index])
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture(perform: {
                                self.selectedItem = index
                                self.showAddIngredientModal = true
                            })
                    }
                    .onMove(perform: { (offsets, targetOffset) in
                        self.recipeDataObserver.draftIngredients.move(fromOffsets: offsets, toOffset: targetOffset)
                    })
                    .onDelete(perform: { offsets in
                        self.recipeDataObserver.draftIngredients.remove(atOffsets: offsets)
                    })
                    .sheet(isPresented: self.$showAddIngredientModal, content: {
                        AddRecipeIngredientModal(
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
                    .sheet(isPresented: self.$showAddIngredientModal, content: {
                        AddRecipeIngredientModal(
                            recipeDataObserver: self.recipeDataObserver,
                            recipe: self.$recipe
                        )
                        .environmentObject(self.objectManager)
                    })
                }
        )
        .environment(\.editMode, self.$editMode)
    }
}

struct AddRecipeIngredientModal: View {
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var recipe: Recipe
    @State var id: String = ""
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
                self.id = self.recipeDataObserver.draftIngredients[self.selectedItem!].id
                self.description = self.recipeDataObserver.draftIngredients[self.selectedItem!].name
                self.quantity = self.recipeDataObserver.draftIngredients[self.selectedItem!].quantity
                self.measurementUnit = self.recipeDataObserver.draftIngredients[self.selectedItem!].unit
            }
        })
    }
    
    func addIngredient() {
        let ingredient = IngredientDraft(id: nil, name: self.description, quantity: self.quantity, unit: self.measurementUnit)
        self.recipeDataObserver.draftIngredients.append(ingredient)
    }
    
    func updateIngredient() {
        self.recipeDataObserver.draftIngredients[selectedItem!] = IngredientDraft(id: self.id, name: self.description, quantity: self.quantity, unit: self.measurementUnit)
    }
}
