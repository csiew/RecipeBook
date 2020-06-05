//
//  AppearanceSettingsView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        List {
            Section {
                NavigationLink("Theme", destination: ThemeSettingsView())
                NavigationLink("Font", destination: FontSettingsView())
            }
            Section(header: Text("Recipes")) {
                Toggle(isOn: $userSettings.listsAreGrouped) {
                    Text("Grouped Lists")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Appearance", displayMode: .inline)
    }
}

struct AppearanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettingsView()
    }
}
