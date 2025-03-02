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
    @State var direction: String
    @State var isEditable: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.primary)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.primary, lineWidth: 1)
                    )
                    .overlay(
                        Text("\(index+1)")
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor.systemBackground))
                    )
                    .frame(idealWidth: 32, maxWidth: 32, idealHeight: 32)
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
