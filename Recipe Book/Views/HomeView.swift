//
//  HomeView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var categoryData: CategoryData
    @EnvironmentObject var userData: UserData
    @State var selectedRecipe: Int = 0
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                List {
                    Section {
                        NavigationLink("Recipes", destination: RecipeList())
                        NavigationLink("Cuisines", destination: CuisineList())
                        NavigationLink("Genres", destination: GenreList())
                    }
                    Section(header: Text("Stats")) {
                        DetailCellView(title: Text("Recipes"), detail: Text("\(self.userData.recipes.count)").foregroundColor(Color.secondary))
                        DetailCellView(title: Text("Cuisines"), detail: Text("\(self.categoryData.cuisines.count)").foregroundColor(Color.secondary))
                        DetailCellView(title: Text("Genres"), detail: Text("\(self.categoryData.genres.count)").foregroundColor(Color.secondary))
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Home", displayMode: .inline)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
