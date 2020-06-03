//
//  RecipeAddView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeAddView: View {
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
        }
    }
}

struct RecipeAddView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeAddView(
            name: recipe1.name,
            description: recipe1.description,
            source: recipe1.source,
            ingredients: recipe1.ingredients,
            directions: recipe1.directions,
            cuisineId: recipe1.cuisineId,
            genreId: recipe1.genreId
        )
    }
}
