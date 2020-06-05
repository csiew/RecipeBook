//
//  ThemeSettingsView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 4/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct ThemeSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                DetailCellView(title: Text("Light"), systemIcon: userSettings.chosenTheme == .light ? "checkmark" : nil)
                    .onTapGesture {
                        print("Set light theme")
                        self.setTheme(theme: .light)
                    }
                DetailCellView(title: Text("Dark"), systemIcon:  userSettings.chosenTheme == .dark ? "checkmark" : nil)
                    .onTapGesture {
                        print("Set dark theme")
                        self.setTheme(theme: .dark)
                    }
                DetailCellView(title: Text("System"), systemIcon: userSettings.chosenTheme == .system ? "checkmark" : nil)
                    .onTapGesture {
                        print("Set system theme")
                        self.setTheme(theme: .system)
                    }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Theme", displayMode: .inline)
    }
    
    func setTheme(theme: ColorSchemeSupplemental) {
        switch theme {
        case .light:
            print("Set light theme")
            self.userSettings.chosenTheme = ColorSchemeSupplemental.light
            self.userSettings.theme = ColorScheme.light
        case .dark:
            print("Set dark theme")
            self.userSettings.chosenTheme = ColorSchemeSupplemental.dark
            self.userSettings.theme = ColorScheme.dark
        case .system:
            print("Set system theme")
            self.userSettings.chosenTheme = ColorSchemeSupplemental.system
            self.userSettings.theme = Environment(\.colorScheme).wrappedValue
        }
    }
}

struct ThemeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSettingsView()
    }
}
