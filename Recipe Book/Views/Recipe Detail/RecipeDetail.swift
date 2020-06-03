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
                    Spacer()
                    if self.recipe.source != "" {
                        Section(header: Text("Source").font(.headline)) {
                                Text(self.recipe.source)
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                        }
                        .padding([.top, .bottom], 8)
                        .frame(maxWidth: reader.size.width, alignment: .topLeading)
                    }
                    Spacer()
                    Section(header: Text("Ingredients").font(.headline)) {
                        if self.recipe.ingredients.count > 0 {
                            VStack {
                                ForEach(1..<self.recipe.ingredients.count, id: \.self) { index in
                                    RecipeIngredientListItem(ingredient: self.recipe.ingredients[index])
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                                        .background(index % 2 != 0 ? Color(UIColor.lightBeige) : Color(UIColor.darkBeige))
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
                                    RecipeDirectionListItem(index: index, direction: self.recipe.directions[index])
                                    .padding(.all, 8)
                                    .frame(maxWidth: reader.size.width, alignment: .leading)
                                        .background(index % 2 != 0 ? Color(UIColor.lightBlue) : Color(UIColor.systemBackground))
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
                    Section {
                        Text("Voila").font(.title)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                    .frame(maxWidth: reader.size.width, alignment: .center)
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
