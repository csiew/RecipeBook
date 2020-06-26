//
//  ContentView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme
 
    var body: some View {
        TabView(selection: $userSettings.selectedTab) {
            RecipeList()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("Recipes")
                    }
                }
                .tag(0)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(1)
        }
        .environment(\.colorScheme, self.userSettings.theme)
        .preferredColorScheme(self.userSettings.theme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CoreDataObjectManager())
            .environmentObject(UserSettings())
    }
}
