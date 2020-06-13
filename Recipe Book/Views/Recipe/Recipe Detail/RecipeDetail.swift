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
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var recipeDataObserver = RecipeDataObserver()
    
    // View initialisers
    @State var editMode: EditMode
    @State var recipe: Recipe? = nil
    
    var isNewRecipe: Bool? = false
    
    // Data
    @State var name: String = ""
    @State var description: String = ""
    @State var source: String = ""
    
    // Flags
    @State var showingIsModifiedAlert: Bool = false
    @State var showAddIngredientModal: Bool = false
    @State var showAddDirectionModal: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                self.recipeDetailBufferView()
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationBarTitle("Recipe")
            .navigationBarBackButtonHidden(self.editMode == .active)
            .navigationBarItems(trailing:
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
            .onAppear(perform: {
                if self.isNewRecipe == true {
                    // Handle new recipe
                    self.recipe = self.objectManager.addRecipe()
                    self.objectManager.save()
                }
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
                self.recipeDataObserver.ingredients.count > 0 ||
                self.recipeDataObserver.directions.count > 0
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
                    ArrayComparison.isMatchingIngredient(array1: self.recipeDataObserver.ingredients, array2: self.recipe!.ingredients.compactMap({ $0 })) == false ||
                    ArrayComparison.isMatchingString(array1: self.recipeDataObserver.directions, array2: self.recipe!.directions) == false
            {
                print("Modifications detected")
                return true
            }
        }
        print("No modifications detected")
        return false
    }
    
    func toggleEditMode() {
        if self.editMode == .active {
            if self.isNewRecipe == true {
                // Handle new recipe
                self.saveRecipe()
            } else {
                // Save modified existing recipe
                self.saveRecipe(existingId: self.recipe!.id)
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
    
    func saveRecipe(existingId: String? = nil) {
        self.recipe?.name = self.name
        self.recipe?.recipeDescription = self.description
        self.recipe?.source = self.source
        self.recipe?.ingredients = Set<Ingredient>(self.recipeDataObserver.ingredients)
        self.recipe?.directions = self.recipeDataObserver.directions
        
        self.objectManager.save()
    }
    
    func loadRecipe() {
        self.name = self.recipe!.name
        self.description = self.recipe!.recipeDescription
        self.source = self.recipe!.source
        self.recipeDataObserver.ingredients = self.recipe!.getIngredients()
        self.recipeDataObserver.directions = self.recipe!.directions
    }
    
    func recipeDetailBufferView() -> AnyView {
        if self.recipe != nil {
            return recipeDetailConditionalView()
        } else {
            return AnyView(
                Text("Loading")
            )
        }
    }
    
    func recipeDetailConditionalView() -> AnyView {
        switch self.editMode {
        case .inactive:
            //MARK: - Read-only view
            return AnyView(
                VStack {
                    Text(self.recipe!.name)
                        .font(.title)
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Spacer()
                    if self.userSettings.allowEstimateDuration == true && self.recipe!.directions.count > 0 {
                        Section(header: Text("Estimated Time Required").font(.headline)) {
                            TimeDisplayView(timeInSeconds: TimeDetection.batchDetect(textValues: self.recipe!.directions))
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                    }
                    if self.recipe!.description != "" {
                        Section(header: Text("Description").font(.headline)) {
                                Text(self.recipe!.recipeDescription)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    Spacer()
                    if self.recipe!.source != "" {
                        Section(header: Text("Source").font(.headline)) {
                                Text(self.recipe!.source)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    Spacer()
                    Section(header: Text("Ingredients").font(.headline)) {
                        if self.recipe!.ingredients.count > 0 {
                            VStack {
                                ForEach(0..<self.recipe!.ingredients.count, id: \.self) { index in
                                    RecipeIngredientListItem(ingredient: self.recipe!.getIngredients()[index])
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
                        if self.recipe!.directions.count > 0 {
                            VStack {
                                ForEach(0..<self.recipe!.directions.count, id: \.self) { index in
                                    RecipeDirectionListItem(index: index, direction: self.recipe!.directions[index])
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
                        Text("\(self.recipeDataObserver.ingredients.count) ingredients").foregroundColor(Color.secondary)
                        NavigationLink(destination: RecipeEditIngredients(recipeDataObserver: self.recipeDataObserver, editMode: self.$editMode, recipe: self.recipe!).environmentObject(self.objectManager)) {
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
                        Text("\(self.recipeDataObserver.directions.count) directions").foregroundColor(Color.secondary)
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
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @Published var ingredients: [Ingredient]
    @Published var directions: [String]
    
    init(ingredients: [Ingredient]? = nil, directions: [String]? = []) {
        self.ingredients = ingredients ?? [Ingredient]()
        self.directions = directions!
    }
}
