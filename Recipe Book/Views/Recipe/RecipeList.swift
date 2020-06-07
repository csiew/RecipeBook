//
//  RecipeList.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

enum RecipeSortingOption {
    case none, ascending, descending
}

struct RecipeGroup {
    var id: String
    var recipes: [Recipe]
}

struct RecipeList: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var categoryData: CategoryData
    @EnvironmentObject var userData: UserData
    @State private var selectedRecipe: Int = 0
    @State private var sortActionSheetVisible: Bool = false
    @State private var sortingOption: RecipeSortingOption = .ascending
    
    func sortedRecipes(sort: RecipeSortingOption) -> [Recipe] {
        switch sort {
        case .none:
            return userData.getRecipes()
        case .ascending:
            return userData.getRecipes().sorted(by: { $0.name < $1.name })
        case .descending:
            return userData.getRecipes().sorted(by: { $0.name > $1.name })
        }
    }
    
    func sortedGroupedRecipes(sort: RecipeSortingOption) -> [RecipeGroup] {
        let preSortedRecipes = sortedRecipes(sort: sort)
        let alphabetGroups = preSortedRecipes.compactMap { $0.name.first }
        var groups = Array<RecipeGroup>()
        alphabetGroups.sorted(by: { $0 < $1 }).forEach { char in
            groups.append(RecipeGroup(id: String(char), recipes: preSortedRecipes.filter { $0.name.first == char }))
        }
        switch sort {
        case .none:
            return groups
        case .ascending:
            return groups.sorted { $0.id < $1.id }
        case .descending:
            return groups.sorted { $0.id > $1.id }
        }
    }
    
    var body: some View {
        List {
            recipeListView()
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Recipes", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button(action: { self.sortActionSheetVisible.toggle() }) {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .actionSheet(isPresented: $sortActionSheetVisible) {
                    ActionSheet(
                        title: Text("Sort by..."),
                        buttons: [
                            .default(Text("Ascending")) { self.sortingOption = .ascending },
                            .default(Text("Descending")) { self.sortingOption = .descending },
                            .cancel()
                        ]
                    )
                }
                NavigationLink(destination: RecipeDetail(recipe: Recipe(), editMode: .active, isNewRecipe: true)) {
                    Image(systemName: "plus")
                }
            }
        )
    }
    
    func recipeListView() -> AnyView {
        switch userSettings.listsAreGrouped {
        case true:
            return AnyView(
                ForEach(sortedGroupedRecipes(sort: sortingOption), id: \.self.id) { group in
                    Section(header: Text(group.id)) {
                        ForEach(group.recipes, id: \.self.id) { recipe in
                            NavigationLink(recipe.name, destination: RecipeDetail(recipe: recipe, editMode: .inactive))
                        }
                    }
                }
            )
        case false:
            return AnyView(
                ForEach(sortedRecipes(sort: sortingOption), id: \.self.id) { recipe in
                    NavigationLink(recipe.name, destination: RecipeDetail(recipe: recipe, editMode: .inactive))
                }
            )
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
    }
}
