//
//  RecipeList.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

enum RecipeSortingOption {
    case none
    case alphanumericAscending, alphanumericDescending
    case dateAscending, dateDescending
}

struct RecipeGroup {
    var id: String
    var recipes: [Recipe]
}

struct RecipeList: View {
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @EnvironmentObject var userSettings: UserSettings
    @State var editMode: EditMode = .inactive
    @State private var showSortingMenu: Bool = false
    @State private var showActionMenu: Bool = false
    @State private var showSettingsModal: Bool = false
    @State private var sortingOption: RecipeSortingOption = .alphanumericAscending
    
    func sortedRecipes(sort: RecipeSortingOption) -> [Recipe] {
        print("Item count: ", objectManager.recipes.count)
        switch sort {
        case .none:
            return objectManager.recipes.compactMap({ $0 })
        case .alphanumericAscending:
            return objectManager.recipes.compactMap({ $0 }).sorted(by: { $0.name < $1.name })
        case .alphanumericDescending:
            return objectManager.recipes.compactMap({ $0 }).sorted(by: { $0.name > $1.name })
        case .dateAscending:
            return objectManager.recipes.compactMap({ $0 }).sorted(by: { $0.dateCreated < $1.dateCreated })
        case .dateDescending:
            return objectManager.recipes.compactMap({ $0 }).sorted(by: { $0.dateCreated > $1.dateCreated })
        }
    }
    
    func sortedGroupedRecipes(sort: RecipeSortingOption) -> [RecipeGroup] {
        let preSortedRecipes = sortedRecipes(sort: sort)
        var groups = Array<RecipeGroup>()
        if sort == .alphanumericAscending || sort == .alphanumericDescending {
            let alphabetGroups = preSortedRecipes.compactMap { $0.name.first }
            alphabetGroups.sorted(by: { $0 < $1 }).forEach { char in
                groups.append(RecipeGroup(id: String(char), recipes: preSortedRecipes.filter { $0.name.first == char }))
            }
        } else if sort == .dateAscending || sort == .dateAscending {
            let dateGroups = preSortedRecipes.compactMap { $0.dateCreated }
            dateGroups.sorted(by: { $0 < $1 }).forEach { dateCreated in
                groups.append(
                    RecipeGroup(
                        id: TimestampUtil.dateToString(date: dateCreated, style: .dateOnly),
                        recipes: preSortedRecipes
                            .filter {
                                TimestampUtil
                                    .dateToString(date: $0.dateCreated, style: .dateOnly) == TimestampUtil.dateToString(date: dateCreated, style: .dateOnly)
                            }
                    )
                )
            }
        }
        switch sort {
        case .none:
            return groups
        case .alphanumericAscending:
            return groups.sorted(by: { $0.id < $1.id })
        case .alphanumericDescending:
            return groups.sorted(by: { $0.id > $1.id })
        case .dateAscending:
            return groups.sorted(by: { $0.id < $1.id })
        case .dateDescending:
            return groups.sorted(by: { $0.id > $1.id })
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                recipeListView()
            }
            .listStyle(DefaultListStyle())
            .navigationBarTitle("Recipes")
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .navigationBarItems(
                leading:
                    HStack {
                        Button(action: {
                            self.editMode.toggle()
                        }) {
                            if self.editMode == .inactive {
                                Text(self.editMode.title)
                            } else {
                                Text(self.editMode.title).bold()
                            }
                        }
                    },
                trailing:
                    HStack {
                        Button(action: {
                            self.showSortingMenu = true
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .actionSheet(isPresented: $showSortingMenu) {
                            ActionSheet(
                                title: Text("Sort by..."),
                                buttons: [
                                    .default(Text("Alphabetical (ascending)")) { self.sortingOption = .alphanumericAscending },
                                    .default(Text("Alphabetical (descending)")) { self.sortingOption = .alphanumericDescending },
                                    .default(Text("Date (ascending)")) { self.sortingOption = .dateAscending },
                                    .default(Text("Date (descending)")) { self.sortingOption = .dateDescending },
                                    .cancel()
                                ]
                            )
                        }
                        .padding(.trailing, 8)
                        NavigationLink(destination: RecipeDetail(editMode: .active, isNewRecipe: true)) {
                            Image(systemName: "square.and.pencil")
                        }
                        .isDetailLink(true)
                    }
            )
        }
        .environment(\.editMode, self.$editMode)
    }
    
    func recipeListView() -> AnyView {
        switch userSettings.listsAreGrouped {
        case true:
            return AnyView(
                ForEach(sortedGroupedRecipes(sort: sortingOption), id: \.self.id) { group in
                    Section(header: Text(group.id)) {
                        ForEach(group.recipes, id: \.self.id) { recipe in
                            NavigationLink(destination: RecipeDetail(editMode: .inactive, recipe: recipe)) {
                                VStack {
                                    Text(recipe.name)
                                }
                            }
                            .isDetailLink(true)
                        }
                    }
                }
                .onDelete(perform: { offsets in
                    self.objectManager.recipes.remove(atOffsets: offsets)
                })
            )
        case false:
            return AnyView(
                ForEach(sortedRecipes(sort: sortingOption), id: \.self.id) { recipe in
                    NavigationLink(destination: RecipeDetail(editMode: .inactive, recipe: recipe)) {
                        VStack {
                            Text(recipe.name)
                        }
                    }
                    .isDetailLink(true)
                }
                .onDelete(perform: { offsets in
                    self.objectManager.recipes.remove(atOffsets: offsets)
                })
            )
        }
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
    }
}
