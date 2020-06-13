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
    @State var selectedRecipe: Int = 0
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                RecipeList()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
