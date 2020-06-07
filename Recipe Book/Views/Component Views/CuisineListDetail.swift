//
//  CuisineListDetail.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct CuisineListDetail: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var categoryData: CategoryData
    @EnvironmentObject var userData: UserData
    var cuisine: Cuisine
    
    var body: some View {
        List {
            ForEach(self.userData.getRecipes().filter { $0.cuisineId == cuisine.id }, id: \.self.id) { recipe in
                NavigationLink(recipe.name, destination: RecipeDetail(recipe: recipe, editMode: .inactive))
            }
        }
        .navigationBarTitle("Recipes", displayMode: .inline)
    }
}

struct CuisineListDetail_Previews: PreviewProvider {
    static var previews: some View {
        CuisineListDetail(cuisine: cuisine1)
    }
}
