//
//  SettingsView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink("General", destination: GeneralSettingsView())
                    NavigationLink("Appearance", destination: AppearanceSettingsView())
                    NavigationLink("Notifications", destination: NotificationsSettingsView())
                    NavigationLink("Account", destination: AccountSettingsView())
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .environment(\.font, userSettings.fontFamily)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
