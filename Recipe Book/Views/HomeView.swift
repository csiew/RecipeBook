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
                        NavigationLink("Recipes",
                                       destination: RecipeList()
                                        .environmentObject(self.userSettings)
                                        .environmentObject(self.categoryData)
                                        .environmentObject(self.userData)
                        )
                        NavigationLink("Cuisines",
                                       destination: CuisineList()
                                        .environmentObject(self.userSettings)
                                        .environmentObject(self.categoryData)
                                        .environmentObject(self.userData)
                        )
                        NavigationLink("Genres",
                                       destination: GenreList()
                                        .environmentObject(self.userSettings)
                                        .environmentObject(self.categoryData)
                                        .environmentObject(self.userData)
                        )
                    }
                }
                .navigationBarTitle("Home", displayMode: .inline)
            }
            .environment(\.font, self.userSettings.fontFamily)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
            .environmentObject(CategoryData())
            .environmentObject(UserData())
    }
}
