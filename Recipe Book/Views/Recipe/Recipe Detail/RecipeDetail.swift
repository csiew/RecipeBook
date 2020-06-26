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
    @State var timeEstimate: Int = 0
    @State var dateCreated: String = ""
    
    // Flags
    @State var showingIsModifiedAlert: Bool = false
    @State var showAddIngredientModal: Bool = false
    @State var showAddDirectionModal: Bool = false
    @State var showActionMenu: Bool = false
    @State var showEditModal: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    Group {
                        Text(self.name)
                            .font(.title)
                            .padding([.top, .bottom], 8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        Text(self.dateCreated)
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                            .padding(.bottom, 8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    Spacer()
                    if self.userSettings.allowEstimateDuration == true && self.recipeDataObserver.draftDirections.count > 0 && self.timeEstimate > 0 {
                        Section(header: Text("Estimated Time Required").font(.headline)) {
                            TimeDisplayView(timeInSeconds: self.timeEstimate)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                    }
                    if self.description != "" {
                        Section(header: Text("Description").font(.headline)) {
                                Text(self.description)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                    }
                    if self.source != "" {
                        Section(header: Text("Source").font(.headline)) {
                                Text(self.source)
                                    .padding(.all, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                    }
                    Section(header: Text("Ingredients").font(.headline)) {
                        if self.recipeDataObserver.draftIngredients.count > 0 {
                            VStack {
                                ForEach(0..<self.recipeDataObserver.draftIngredients.count, id: \.self) { index in
                                    RecipeIngredientDraftListItem(ingredient: self.recipeDataObserver.draftIngredients[index])
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
                        if self.recipeDataObserver.draftDirections.count > 0 {
                            VStack {
                                ForEach(0..<self.recipeDataObserver.draftDirections.count, id: \.self) { index in
                                    RecipeDirectionListItem(index: index, direction: self.recipeDataObserver.draftDirections[index])
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
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationBarTitle("Recipe", displayMode: .inline)
            .navigationBarBackButtonHidden(self.editMode == .active)
            .navigationBarItems(
                trailing:
                    HStack {
                        Button(action: { self.showActionMenu = true }) {
                            Image(systemName: "ellipsis")
                        }
                        .actionSheet(isPresented: self.$showActionMenu) {
                            ActionSheet(
                                title: Text("Actions"),
                                buttons: [
                                    .default(Text("Edit")) {
                                        self.showEditModal = true
                                    },
                                    .destructive(Text("Delete")) {
                                        print("TODO: Implement delete action")
                                    },
                                    .cancel()
                                ]
                            )
                        }
                    }
            )
            .environment(\.editMode, self.$editMode)
            .onAppear(perform: {
                if self.isNewRecipe == true {
                    // Handle new recipe
                    self.recipe = self.objectManager.addRecipe()
                    self.objectManager.save()
                } else {
                    if self.editMode == .inactive {
                        self.timeEstimate = TimeDetection.batchDetect(textValues: self.recipe!.directions)
                    }
                }
                self.loadRecipe()
            })
            .sheet(isPresented: self.$showEditModal) {
                RecipeDetailEdit(
                    recipeDataObserver: self.recipeDataObserver,
                    recipe: self.recipe
                )
                .environmentObject(self.objectManager)
            }
        }
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

class RecipeDataObserver: ObservableObject {
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @Published var draftIngredients: [IngredientDraft]
    @Published var draftDirections: [String]
    
    init(ingredients: [Ingredient] = [], directions: [String] = []) {
        self.draftIngredients = RecipeDataObserver.addIngredients(unconverted: ingredients)
        self.draftDirections = directions
    }
    
    func loadIngredients(ingredients: [Ingredient]) {
        self.draftIngredients = RecipeDataObserver.addIngredients(unconverted: ingredients)
    }
    
    func loadDirections(directions: [String]) {
        self.draftDirections = directions
    }
    
    static func addIngredients(unconverted: [Ingredient]) -> [IngredientDraft] {
        var draft = [IngredientDraft]()
        for ingredient in unconverted {
            let converted = IngredientDraft(id: ingredient.id, name: ingredient.name, quantity: ingredient.quantity, unit: MeasurementUnit.init(rawValue: ingredient.unit))
            draft.append(converted)
        }
        return draft
    }
}
