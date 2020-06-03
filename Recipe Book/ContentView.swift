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
                .environmentObject(userSettings)
                .environmentObject(userData)
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            Text("Categories")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Categories")
                    }
                }
                .tag(1)
            SettingsView()
                .environmentObject(userSettings)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
        .environment(\.colorScheme, userSettings.theme)
        .preferredColorScheme(userSettings.theme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(UserData())
    }
}
