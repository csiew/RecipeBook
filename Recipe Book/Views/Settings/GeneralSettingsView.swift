//
//  GeneralSettingsView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        List {
            Section(header: Text("Duration"), footer: Text("The time required to complete the recipe searches for mentions of time duration within the recipe directions and sums it up.")) {
                Toggle(isOn: $userSettings.allowEstimateDuration) {
                    Text("Estimate duration")
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("General", displayMode: .inline)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
