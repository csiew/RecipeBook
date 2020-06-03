//
//  RecipeDetail.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    Text(self.recipe.name).font(.title)
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: reader.size.width, alignment: .topLeading)
                    Spacer()
                    if self.recipe.description != "" {
                        Section(header: Text("Description").font(.headline)) {
                                Text(self.recipe.description)
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: reader.size.width, alignment: .topLeading)
                    }
                    Section(header: Text("Ingredients").font(.headline)) {
                        if self.recipe.ingredients.count > 0 {
                            VStack {
                                ForEach(1..<self.recipe.ingredients.count, id: \.self) { index in
                                    HStack {
                                        Text(self.recipe.ingredients[index].name)
                                            .lineLimit(nil)
                                        Spacer()
                                        if self.recipe.ingredients[index].quantity != nil {
                                            Text("\(self.recipe.ingredients[index].quantity!)")
                                        }
                                    }
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                                    .background(index % 2 != 0 ? Color(UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.00)) : Color(UIColor.systemBackground))
                                }
                            }
                            .frame(maxWidth: reader.size.width)
                        } else {
                            Text("No ingredients for this recipe")
                                .foregroundColor(.secondary)
                        }
                    }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: reader.size.width, alignment: .topLeading)
                    Spacer()
                    Section(header: Text("Directions").font(.headline)) {
                        if self.recipe.directions.count > 0 {
                            VStack {
                                ForEach(1..<self.recipe.directions.count, id: \.self) { index in
                                    HStack {
                                        HStack {
                                            Circle()
                                            .foregroundColor(Color.red)
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(Color.red, lineWidth: 1)
                                            )
                                            .overlay(
                                                Text("\(index)")
                                                    .bold()
                                                    .foregroundColor(.white)
                                            )
                                                .frame(idealWidth: 32, maxWidth: 32, idealHeight: 32)
                                        }
                                        .padding(.trailing, 8)
                                        .frame(alignment: .topLeading)
                                        Text(self.recipe.directions[index])
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                                    .background(index % 2 != 0 ? Color(UIColor(red: 0.8, green: 0.9, blue: 0.95, alpha: 1.00)) : Color(UIColor.systemBackground))
                                }
                            }
                            .frame(maxWidth: reader.size.width)
                        } else {
                            Text("No directions for this recipe")
                                .foregroundColor(.secondary)
                        }
                    }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: reader.size.width, alignment: .topLeading)
                }
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 16)
                .frame(maxWidth: reader.size.width, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: reader.size.width, maxHeight: reader.size.height, alignment: .topLeading)
            .navigationBarTitle(Text("Recipe"), displayMode: .inline)
            .navigationBarBackButtonHidden(false)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        print("Edit button pressed")
                    }, label: { Text("Edit") })
                }
            )
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetail(recipe: recipe1)
    }
}
