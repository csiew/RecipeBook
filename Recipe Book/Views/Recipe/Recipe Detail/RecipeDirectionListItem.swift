//
//  RecipeDirectionListItem.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct RecipeDirectionListItem: View {
    var index: Int
    var direction: String
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                .foregroundColor(Color.red)
                .overlay(
                    Circle()
                        .strokeBorder(Color.red, lineWidth: 1)
                )
                .overlay(
                    Text("\(index+1)")
                        .bold()
                        .foregroundColor(.white)
                )
                .frame(minWidth: 32, maxWidth: 32, idealHeight: 32)
                .fixedSize()
            }
            .padding(.bottom, 8)
            Text(direction)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RecipeDirectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDirectionListItem(index: 1, direction: "Preheat oven to 190ºC.")
    }
}
