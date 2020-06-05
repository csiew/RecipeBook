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
    @EnvironmentObject var userData: UserData
    @State var recipe: Recipe
    @State var editMode: EditMode = .inactive
    @State var showingIsModifiedAlert: Bool = false
    @State var name: String = ""
    @State var description: String = ""
    @State var source: String = ""
    @State var ingredients: [RecipeIngredient] = Array<RecipeIngredient>()
    @State var directions: [String] = Array<String>()
    @State var cuisineId: String?
    @State var genreId: String?
    
    @State private var ingredientsOffset = CGSize.zero
    
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
                                if self.isModified() {
                                    self.showingIsModifiedAlert.toggle()
                                } else {
                                    self.toggleEditMode(isCancel: true)
                                }
                            })
                            .alert(isPresented: self.$showingIsModifiedAlert) {
                                Alert(
                                    title: Text("Edit Recipe"),
                                    message: Text("Are you sure you want to discard the changes you have made?"),
                                    primaryButton: .destructive(Text("Yes").bold(), action: {
                                        self.editMode.toggle()
                                    }),
                                    secondaryButton: .default(Text("Continue Editing"))
                                )
                            }
                        }
                    },
                trailing:
                    HStack {
                        Button(action: { self.toggleEditMode() }) {
                            Text(self.editMode.title)
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
            ArrayComparison.isMatchingIngredient(array1: self.ingredients, array2: self.recipe.ingredients) == false ||
            ArrayComparison.isMatchingString(array1: self.directions, array2: self.recipe.directions) == false ||
            self.cuisineId != self.recipe.cuisineId ||
            self.genreId != self.recipe.genreId
        {
            print("Modifications detected")
            return true
        }
        return false
    }
    
    func toggleEditMode(isCancel: Bool = false) {
        if self.editMode == .active {
            if isCancel == true && self.isModified() == true {
                // Handle cancelling when changes have been made
                self.showingIsModifiedAlert.toggle()
            } else if isCancel == false && self.isModified() == true {
                // Handle saving
                self.recipe = self.saveRecipe()
                self.editMode.toggle()
            } else {
                self.editMode.toggle()
            }
        } else {
            self.loadRecipe()
            self.editMode.toggle()
        }
    }
    
    func saveRecipe() -> Recipe {
        let recipeId = self.recipe.id
        let modifiedRecipe = Recipe(id: recipeId, name: self.name, description: self.description, source: self.source, cuisineId: self.cuisineId, genreId: self.genreId, ingredients: self.ingredients, directions: self.directions)
        userData.setRecipe(recipe: modifiedRecipe)
        return modifiedRecipe
    }
    
    func loadRecipe() {
        self.name = self.recipe.name
        self.description = self.recipe.description
        self.source = self.recipe.source
        self.ingredients = self.recipe.ingredients
        self.directions = self.recipe.directions
        self.cuisineId = self.recipe.cuisineId
        self.genreId = self.recipe.genreId
    }
    
    func recipeDetailConditionalView() -> AnyView {
        switch self.editMode {
        case .inactive:
            return AnyView(
                VStack {
                    Text(self.recipe.name)
                        .font(.title)
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
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
                                ForEach(1..<self.recipe.ingredients.count, id: \.self) { index in
                                    RecipeIngredientListItem(ingredient: self.recipe.ingredients[index])
                                    .padding(.all, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(index % 2 != 0 ? Color(UIColor.lightBeige) : Color(UIColor.darkBeige))
                                }
                            }
                            .frame(maxWidth: .infinity)
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
                                ForEach(1..<self.recipe.directions.count, id: \.self) { index in
                                    RecipeDirectionListItem(index: index, direction: self.recipe.directions[index])
                                    .padding(.all, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(index % 2 != 0 ? Color(UIColor.lightBlue) : Color(UIColor.systemBackground))
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
                    Section {
                        Text("Voila").font(.title)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        case .active:
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
                        if self.ingredients.count > 0 {
                            VStack {
                                ForEach(1..<self.ingredients.count, id: \.self) { index in
                                    HStack {
                                        Button(action: { self.ingredients.remove(at: index) }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color(UIColor.systemRed))
                                        }
                                        RecipeIngredientListItem(ingredient: self.ingredients[index])
                                            .padding(.all, 8)
                                        Image(systemName: "line.horizontal.3")
                                            .foregroundColor(Color.secondary)
                                            .padding(.leading, 8)
                                    }
                                    .padding(.all, 8)
                                    .background(index % 2 != 0 ? Color(UIColor.lightBeige) : Color(UIColor.darkBeige))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .cornerRadius(8)
                                    .rotationEffect(.degrees(Double(self.ingredientsOffset.width / 5)))
                                    .offset(x: self.ingredientsOffset.width, y: self.ingredientsOffset.height)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                self.ingredientsOffset = gesture.translation
                                            }

                                            .onEnded { _ in
                                                self.ingredientsOffset = .zero
                                            }
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity)
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
                                ForEach(1..<self.recipe.directions.count, id: \.self) { index in
                                    RecipeDirectionListItem(index: index, direction: self.recipe.directions[index])
                                    .padding(.all, 8)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(index % 2 != 0 ? Color(UIColor.lightBlue) : Color(UIColor.systemBackground))
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
                    Section {
                        Text("Voila").font(.title)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                    .frame(maxWidth: .infinity, alignment: .center)
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

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: recipe1)
    }
}
