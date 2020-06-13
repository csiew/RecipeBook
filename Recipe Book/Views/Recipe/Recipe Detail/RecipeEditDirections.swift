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
    @ObservedObject var recipeDataObserver: RecipeDataObserver
    @Binding var editMode: EditMode
    @State var showAddDirectionModal: Bool = false
    @State var selectedItem: Int? = nil
    
    var body: some View {
        Group {
            if self.recipeDataObserver.directions.count == 0 {
                Text("No directions for this recipe")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List {
                    ForEach(0..<recipeDataObserver.directions.count, id: \.self) { index in
                        RecipeDirectionListItem(index: index, direction: self.recipeDataObserver.directions[index])
                            .padding(.all, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture(perform: {
                                self.selectedItem = index
                                self.showAddDirectionModal = true
                            })
                    }
                    .onMove(perform: { (offsets, targetOffset) in
                        self.recipeDataObserver.directions.move(fromOffsets: offsets, toOffset: targetOffset)
                    })
                    .onDelete(perform: { offsets in
                        self.recipeDataObserver.directions.remove(atOffsets: offsets)
                    })
                    .sheet(isPresented: self.$showAddDirectionModal, content: {
                        AddRecipeDirectionModal(
                            recipeDataObserver: self.recipeDataObserver,
                            selectedItem: self.selectedItem
                        )
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
                            recipeDataObserver: self.recipeDataObserver
                        )
                    })
                }
        )
        .environment(\.editMode, self.$editMode)
    }
}

struct AddRecipeDirectionModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeDataObserver: RecipeDataObserver
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
                            Text("\((selectedItem ?? self.recipeDataObserver.directions.count) + 1)")
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
                    self.description = self.recipeDataObserver.directions[self.selectedItem!]
                    print(self.description)
                }
            })
        }
    }
    
    func addDirection() {
        self.recipeDataObserver.directions.append(self.description)
    }
    
    func updateDirection() {
        if self.selectedItem != nil {
            self.recipeDataObserver.directions[self.selectedItem!] = self.description
        }
    }
}
