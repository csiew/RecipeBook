//
//  RecipeEditDirections.swift
//  Recipe Book
//
//  Created by Clarence Siew on 8/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeEditDirections: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @State var recipe: Recipe
    @State var showAddDirectionModal: Bool = false
    @State var selectedItem: Int? = nil
    @State var editMode: EditMode = .active
    
    var body: some View {
        Group {
            if self.recipeDataObserver.draftDirections.count == 0 {
                Text("No directions for this recipe")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(0..<recipeDataObserver.draftDirections.count, id: \.self) { index in
                        RecipeDirectionListItem(index: index, direction: self.recipeDataObserver.draftDirections[index])
                            .padding(.all, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture(perform: {
                                self.selectedItem = index
                                self.showAddDirectionModal = true
                            })
                    }
                    .onMove(perform: { (offsets, targetOffset) in
                        self.recipeDataObserver.draftDirections.move(fromOffsets: offsets, toOffset: targetOffset)
                    })
                    .onDelete(perform: { offsets in
                        self.recipeDataObserver.draftDirections.remove(atOffsets: offsets)
                    })
                    .sheet(isPresented: self.$showAddDirectionModal, content: {
                        AddRecipeDirectionModal(
                            recipeDataObserver: self.recipeDataObserver,
                            recipe: self.$recipe,
                            selectedItem: self.selectedItem
                        )
                        .environmentObject(self.objectManager)
                        .onDisappear(perform: {
                            self.selectedItem = nil
                        })
                    })
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationBarTitle("Directions", displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack {
                    Button(action: { self.showAddDirectionModal = true }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showAddDirectionModal, content: {
                        AddRecipeDirectionModal(
                            recipeDataObserver: self.recipeDataObserver,
                            recipe: self.$recipe
                        )
                        .environmentObject(self.objectManager)
                    })
                }
        )
        .environment(\.editMode, self.$editMode)
    }
}

struct AddRecipeDirectionModal: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var objectManager: CoreDataObjectManager
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var recipe: Recipe
    @State var selectedItem: Int? = nil
    @State var description: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Circle()
                        .fill(Color.primary)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary, lineWidth: 1)
                        )
                        .overlay(
                            Text("\((selectedItem ?? self.recipeDataObserver.draftDirections.count) + 1)")
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor.systemBackground))
                        )
                        .frame(idealWidth: 32, maxWidth: 32, idealHeight: 32)
                        .fixedSize()
                }
                .padding(.top, 16)
                MultilineTextField(text: self.$description, isFirstResponder: true)
                    .font(.body)
                    .padding(.all, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarTitle("Add Direction", displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            HStack {
                                Button("Cancel", action: { self.presentationMode.wrappedValue.dismiss() })
                            },
                        trailing:
                            HStack {
                                Button(action: {
                                    if self.selectedItem == nil {
                                        self.addDirection()
                                    } else {
                                        self.updateDirection()
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Done").bold()
                                }
                                .disabled(self.description.isEmpty)
                            }
                        )
            }
            .onAppear(perform: {
                if self.selectedItem != nil {
                    self.description = self.recipeDataObserver.draftDirections[self.selectedItem!]
                    print(self.description)
                }
            })
        }
    }
    
    func addDirection() {
        self.recipe.directions.append(self.description)
        self.recipeDataObserver.draftDirections.append(self.description)
        self.objectManager.save()
    }
    
    func updateDirection() {
        if self.selectedItem != nil {
            self.recipe.directions[self.selectedItem!] = self.description
            self.recipeDataObserver.draftDirections[self.selectedItem!] = self.description
            self.objectManager.save()
        }
    }
}
