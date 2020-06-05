//
//  FontSettingsView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 4/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct FontSettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section(footer: Text("These changes will take effect after restarting the app.")) {
                DetailCellView(title: Text("San Francisco").font(FontScheme.sanfran()), systemIcon: userSettings.chosenFontFamily == .SanFrancisco ? "checkmark" : nil)
                    .onTapGesture {
                        print("San Fran")
                        self.setFontFamily(font: .SanFrancisco)
                    }
                DetailCellView(title: Text("Public Sans").font(FontScheme.publicsans()), systemIcon: userSettings.chosenFontFamily == .PublicSans ? "checkmark" : nil)
                    .onTapGesture {
                        print("Public Sans")
                        self.setFontFamily(font: .PublicSans)
                    }
                DetailCellView(title: Text("Fira Sans").font(FontScheme.firasans()), systemIcon: userSettings.chosenFontFamily == .FiraSans ? "checkmark" : nil)
                    .onTapGesture {
                        print("Fira Sans")
                        self.setFontFamily(font: .FiraSans)
                    }
                DetailCellView(title: Text("Gelasio").font(FontScheme.gelasio()), systemIcon: userSettings.chosenFontFamily == .Gelasio ? "checkmark" : nil)
                    .onTapGesture {
                        print("Gelasio")
                        self.setFontFamily(font: .Gelasio)
                    }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Font", displayMode: .inline)
    }
    
    func setFontFamily(font: FontSchemeSupplemental) {
        switch font {
        case .SanFrancisco:
            self.userSettings.chosenFontFamily = FontSchemeSupplemental.SanFrancisco
            self.userSettings.fontFamily = Environment(\.font).wrappedValue
        case .PublicSans:
            self.userSettings.chosenFontFamily = FontSchemeSupplemental.PublicSans
            self.userSettings.fontFamily = FontScheme.publicsans()
        case .FiraSans:
            self.userSettings.chosenFontFamily = FontSchemeSupplemental.FiraSans
            self.userSettings.fontFamily = FontScheme.firasans()
        case .Gelasio:
            self.userSettings.chosenFontFamily = FontSchemeSupplemental.Gelasio
            self.userSettings.fontFamily = FontScheme.gelasio()
        }
    }
}

struct FontSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FontSettingsView()
    }
}
