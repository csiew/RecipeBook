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
            Section {
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
