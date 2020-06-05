//
//  ContentView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userData: UserData
 
    var body: some View {
        TabView(selection: $userSettings.selectedTab) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            PantryView()
                .tabItem {
                    VStack {
                        Image(systemName: "cube.box")
                        Text("Pantry")
                    }
                }
                .tag(1)
            Text("Salon")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right")
                        Text("Salon")
                    }
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(3)
        }
        .environment(\.colorScheme, self.userSettings.theme)
        .preferredColorScheme(self.userSettings.theme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(UserData())
    }
}
