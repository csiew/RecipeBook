//
//  RecipeDetailEdit.swift
//  Recipe Book
//
//  Created by Clarence Siew on 27/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeDetailEdit: View {
    // Observers
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    
    // View initialisers
    @State var recipe: Recipe? = nil
    var isNewRecipe: Bool? = false
    
    // Data
    @State var name: String = ""
    @State var description: String = ""
    @State var source: String = ""
    @State var timeEstimate: Int = 0
    @State var dateCreated: String = ""
    
    // Flags
    @State var showModifiedAlert: Bool = false
    @State var showAddIngredientModal: Bool = false
    @State var showAddDirectionModal: Bool = false
    @State var showActionMenu: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Name", text: self.$name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .allowsTightening(true)
                        .font(.title)
                        .padding(.all, 4)
                        .background(Color(.secondarySystemFill))
                        .cornerRadius(8)
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Description").font(.headline)) {
                        MultilineTextField(text: self.$description)
                            .font(.body)
                            .padding(.all, 4)
                            .background(Color(.secondarySystemFill))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, idealHeight: 120, alignment: .leading)
                    }
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Source").font(.headline)) {
                        TextField("Source", text: self.$source)
                            .textFieldStyle(PlainTextFieldStyle())
                            .allowsTightening(true)
                            .padding(.all, 4)
                            .background(Color(.secondarySystemFill))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Ingredients").font(.headline)) {
                        Text("\(self.recipeDataObserver.draftIngredients.count) ingredients").foregroundColor(Color.secondary)
                        NavigationLink(destination: RecipeEditIngredients(recipeDataObserver: self.recipeDataObserver, recipe: self.recipe!).environmentObject(self.objectManager)) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Ingredients").bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, 16)
                        .background(Color.accentColor)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                    }
                    .padding([.top, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Directions").font(.headline)) {
                        Text("\(self.recipeDataObserver.draftDirections.count) directions").foregroundColor(Color.secondary)
                        NavigationLink(destination: RecipeEditDirections(recipeDataObserver: self.recipeDataObserver, recipe: self.recipe!).environmentObject(self.objectManager)) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Directions").bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, 16)
                        .background(Color.accentColor)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                    }
                    .padding([.top, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationBarTitle("Recipe", displayMode: .inline)
            .navigationBarItems(
                leading:
                    HStack {
                        Button("Cancel") {
                            if self.isModified() == true {
                                self.showModifiedAlert = true
                            } else {
                                self.toggleEditMode(save: false)
                            }
                        }
                        .alert(isPresented: self.$showModifiedAlert) {
                            if self.isNewRecipe == true {
                                return Alert(
                                    title: Text("Add Recipe"),
                                    message: Text("It looks like you had something going. Are you sure you want to cancel creating your new recipe?"),
                                    primaryButton: .destructive(Text("Discard"), action: {
                                        self.toggleEditMode(save: false)
                                    }),
                                    secondaryButton: .default(Text("Cancel"))
                                )
                            } else {
                                return Alert(
                                    title: Text("Edit Recipe"),
                                    message: Text("There are unsaved changes. Are you sure you want to discard changes?"),
                                    primaryButton: .destructive(Text("Discard"), action: {
                                        self.toggleEditMode(save: false)
                                    }),
                                    secondaryButton: .default(Text("Cancel"))
                                )
                            }
                        }
                    },
                trailing:
                    HStack {
                        Button(action: { self.toggleEditMode() }) {
                            Text("Done").bold()
                        }
                    }
                )
            .onAppear(perform: {
                self.loadRecipe()
            })
        }
    }
    
    func isModified() -> Bool {
        if self.isNewRecipe == true {
            // Handle new recipe
            if
                !self.name.isEmpty ||
                !self.description.isEmpty ||
                !self.source.isEmpty ||
                self.recipeDataObserver.draftIngredients.count > 0 ||
                self.recipeDataObserver.draftDirections.count > 0
            {
                print("Modifications detected")
                return true
            }
        } else {
            // Handle existing recipe
            if
                self.name != self.recipe!.name ||
                    self.description != self.recipe!.recipeDescription ||
                    self.source != self.recipe!.source ||
                    ArrayComparison.isMatchingIngredient(array1: self.recipeDataObserver.draftIngredients, array2: self.recipe!.ingredients.compactMap({ $0 })) == false ||
                    ArrayComparison.isMatchingString(array1: self.recipeDataObserver.draftDirections, array2: self.recipe!.directions) == false
            {
                print("Modifications detected")
                return true
            }
        }
        print("No modifications detected")
        return false
    }
    
    func toggleEditMode(save: Bool = true) {
        if save == true {
            if self.isNewRecipe == true {
                // Handle new recipe
                self.saveRecipe()
            } else {
                // Save modified existing recipe
                self.saveRecipe(existingId: self.recipe!.id)
            }
        } else {
            if self.isNewRecipe == true {
                // Discard new recipe on cancel
                self.objectManager.managedObjectContext.delete(self.recipe!)
                self.objectManager.save()
            }
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func saveRecipe(existingId: String? = nil) {
        self.recipe?.name = self.name
        self.recipe?.recipeDescription = self.description
        self.recipe?.source = self.source
        // Convert and replace ingredients
        var convertedIngredients = Set<Ingredient>()
        self.recipeDataObserver.draftIngredients.forEach { ingredient in
            let newIngredient = Ingredient(permanent: true, insertIntoManagedObjectContext: self.objectManager.managedObjectContext, id: nil, name: ingredient.name, quantity: ingredient.quantity, unit: ingredient.getUnit(), recipe: self.recipe!)
            convertedIngredients.insert(newIngredient)
        }
        self.recipe?.ingredients = convertedIngredients
        self.recipe?.directions = self.recipeDataObserver.draftDirections
        
        self.objectManager.save()
        self.loadRecipe()
    }
    
    func loadRecipe() {
        self.name = self.recipe!.name
        self.description = self.recipe!.recipeDescription
        self.source = self.recipe!.source
        self.recipeDataObserver.loadIngredients(ingredients: self.recipe!.getIngredients())
        self.recipeDataObserver.loadDirections(directions: self.recipe!.directions)
        self.dateCreated = TimestampUtil.dateToString(date: self.recipe!.dateCreated, style: .casualLong)
    }
}

struct RecipeDetailEdit_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailEdit(recipeDataObserver: RecipeDataObserver())
    }
}
