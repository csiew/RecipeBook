//
//  RecipeAddView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var showingIsModifiedAlert: Bool = false
    @State var name: String = ""
    @State var description: String = ""
    @State var source: String = ""
    @State var ingredients: [RecipeIngredient] = Array<RecipeIngredient>()
    @State var directions: [String] = Array<String>()
    @State var cuisineId: String?
    @State var genreId: String?
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    Section {
                        VStack {
                            Text("Name")
                                .bold()
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: reader.size.width, alignment: .topLeading)
                                .padding([.top, .leading, .trailing], 8)
                            TextField("Name", text: self.$name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.bottom, 8)
                        VStack {
                            Text("Description")
                                .bold()
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: reader.size.width, alignment: .topLeading)
                                .padding([.top, .leading, .trailing], 8)
                            TextField("Description", text: self.$description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                        .padding(.bottom, 8)
                        VStack {
                            Text("Source")
                                .bold()
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: reader.size.width, alignment: .topLeading)
                                .padding([.top, .leading, .trailing], 8)
                            TextField("Source", text: self.$source)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.bottom, 8)
                    }
                    .frame(maxWidth: reader.size.width, maxHeight: reader.size.height, alignment: .topLeading)
                }
                .padding(.all, 16)
                .frame(maxWidth: reader.size.width, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: reader.size.width, maxHeight: reader.size.height, alignment: .topLeading)
            .navigationBarTitle(Text("Add Recipe"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack {
                    Button("Cancel", action: {
                        if self.isModified() {
                            self.showingIsModifiedAlert.toggle()
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    })
                    .alert(isPresented: self.$showingIsModifiedAlert) {
                        Alert(
                            title: Text("Add Recipe"),
                            message: Text("It looks like you had something going. Are you sure you want to cancel creating your new recipe?"),
                            primaryButton: .destructive(Text("Yes").bold(), action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }),
                            secondaryButton: .default(Text("Continue Editing"))
                        )
                    }
                }
            )
        }
    }
    
    func isModified() -> Bool {
        if self.name != "" || self.description != "" || self.source != "" || self.ingredients.count > 0 || self.directions.count > 0 || self.cuisineId != nil || self.genreId != nil {
            return true
        }
        return false
    }
}
