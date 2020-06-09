//
//  RecipeDetail.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation
import SwiftUI

struct RecipeDetail: View {
    // Observers
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var recipeDataObserver = RecipeDataObserver()
    
    // View initialisers
    @State var recipe: Recipe
    @State var editMode: EditMode
    
    // Data
    @State var name: String = ""
    @State var description: String = ""
    @State var source: String = ""
    @State var cuisineId: String?
    @State var genreId: String?
    
    // Flags
    @State var isNewRecipe: Bool? = false
    @State var showingIsModifiedAlert: Bool = false
    @State var showAddIngredientModal: Bool = false
    @State var showAddDirectionModal: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                self.recipeDetailConditionalView()
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationBarTitle("Recipe")
            .navigationBarBackButtonHidden(self.editMode == .active)
            .navigationBarItems(
                leading:
                    HStack {
                        if self.editMode == .active {
                            Button("Cancel", action: {
                                if self.isModified() == true {
                                    self.showingIsModifiedAlert.toggle()
                                } else {
                                    self.toggleEditMode()
                                }
                            })
                            .alert(isPresented: self.$showingIsModifiedAlert) {
                                if self.isNewRecipe == false {
                                    return Alert(
                                        title: Text("Edit Recipe"),
                                        message: Text("Are you sure you want to discard the changes you have made?"),
                                        primaryButton: .destructive(Text("Yes").bold(), action: {
                                            self.editMode.toggle()
                                        }),
                                        secondaryButton: .default(Text("Continue Editing"))
                                    )
                                } else {
                                    return Alert(
                                        title: Text("Add Recipe"),
                                        message: Text("It looks like you had something going. Are you sure you want to cancel creating your new recipe?"),
                                        primaryButton: .destructive(Text("Yes").bold(), action: {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }),
                                        secondaryButton: .default(Text("Continue Editing"))
                                    )
                                }
                            }
                        }
                    },
                trailing:
                    HStack {
                        Button(action: { self.toggleEditMode() }) {
                            if self.editMode == .inactive {
                                Text(self.editMode.title)
                            } else {
                                Text(self.editMode.title).bold()
                            }
                        }
                    }
            )
            .environment(\.editMode, self.$editMode)
        }
    }
    
    func isModified() -> Bool {
        if
            self.name != self.recipe.name ||
            self.description != self.recipe.description ||
            self.source != self.recipe.source ||
            ArrayComparison.isMatchingIngredientContent(array1: self.recipeDataObserver.ingredients, array2: self.recipe.ingredients) == false ||
            ArrayComparison.isMatchingString(array1: self.recipeDataObserver.directions, array2: self.recipe.directions) == false ||
            self.cuisineId != self.recipe.cuisineId ||
            self.genreId != self.recipe.genreId
        {
            print("Modifications detected")
            return true
        }
        print("No modifications detected")
        return false
    }
    
    func toggleEditMode() {
        if self.editMode == .active {
            if self.isNewRecipe == false {
                if self.isModified() == true {
                    self.recipe = self.saveRecipe()
                }
            } else {
                let newRecipe = Recipe(id: nil, name: self.name, description: self.description, source: self.source, cuisineId: self.cuisineId, genreId: self.genreId, ingredients: self.recipeDataObserver.ingredients, directions: self.recipeDataObserver.directions)
                self.userData.recipes[newRecipe.id] = newRecipe
            }
            self.editMode.toggle()
            if self.isNewRecipe == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        } else {
            self.loadRecipe()
            self.editMode.toggle()
        }
    }
    
    func saveRecipe() -> Recipe {
        let modifiedRecipe = Recipe(id: self.recipe.id, name: self.name, description: self.description, source: self.source, cuisineId: self.cuisineId, genreId: self.genreId, ingredients: self.recipeDataObserver.ingredients, directions: self.recipeDataObserver.directions)
        userData.setRecipe(recipe: modifiedRecipe)
        return modifiedRecipe
    }
    
    func loadRecipe() {
        self.name = self.recipe.name
        self.description = self.recipe.description
        self.source = self.recipe.source
        self.recipeDataObserver.ingredients = self.recipe.ingredients
        self.recipeDataObserver.directions = self.recipe.directions
        self.cuisineId = self.recipe.cuisineId
        self.genreId = self.recipe.genreId
    }
    
    func recipeDetailConditionalView() -> AnyView {
        switch self.editMode {
        case .inactive:
            //MARK: - Read-only view
            return AnyView(
                VStack {
                    Text(self.recipe.name)
                        .font(.title)
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    if self.userSettings.allowEstimateDuration == true && self.recipe.directions.count > 0 {
                        Section(header: Text("Estimated Time Required").font(.headline)) {
                            TimeDisplayView(timeInSeconds: TimeDetection.batchDetect(textValues: self.recipe.directions))
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                    }
                    if self.recipe.description != "" {
                        Section(header: Text("Description").font(.headline)) {
                                Text(self.recipe.description)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    Spacer()
                    if self.recipe.source != "" {
                        Section(header: Text("Source").font(.headline)) {
                                Text(self.recipe.source)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    Spacer()
                    Section(header: Text("Ingredients").font(.headline)) {
                        if self.recipe.ingredients.count > 0 {
                            VStack {
                                ForEach(0..<self.recipe.ingredients.count, id: \.self) { index in
                                    RecipeIngredientListItem(ingredient: self.recipe.ingredients[index])
                                        .padding(.all, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(index % 2 == 0 ? Color(UIColor.lightBeige) : Color(UIColor.darkBeige))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                        } else {
                            Text("No ingredients for this recipe")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding([.top, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Directions").font(.headline)) {
                        if self.recipe.directions.count > 0 {
                            VStack {
                                ForEach(0..<self.recipe.directions.count, id: \.self) { index in
                                    RecipeDirectionListItem(index: index, direction: self.recipe.directions[index])
                                        .padding(.all, 16)
                                        .frame(maxWidth: .infinity, alignment: .top)
                                        .background(Color(UIColor.lightBeige))
                                        .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("No directions for this recipe")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding([.top, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            )
        case .active:
            //MARK: - Edit view
            return AnyView(
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
                        NavigationLink(destination: RecipeEditIngredients(recipeDataObserver: self.recipeDataObserver, editMode: self.$editMode)) {
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
                        NavigationLink(destination: RecipeEditDirections(recipeDataObserver: self.recipeDataObserver, editMode: self.$editMode)) {
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
            )
        case .transient:
            self.toggleEditMode()
            return AnyView(
                Text("Unknown error occurred: Please restart the app")
            )
        @unknown default:
            self.toggleEditMode()
            return AnyView(
                Text("Unknown error occurred: Please restart the app")
            )
        }
    }
}

class RecipeDataObserver: ObservableObject {
    @Published var ingredients: [RecipeIngredient]
    @Published var directions: [String]
    
    init(ingredients: [RecipeIngredient]? = [], directions: [String]? = []) {
        self.ingredients = ingredients!
        self.directions = directions!
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: recipe1, editMode: .inactive)
    }
}
