//
//  Category.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

struct RecipeCategory: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    
    init(id: String? = UUID().uuidString, name: String, description: String? = "") {
        self.id = id!
        self.name = name
        self.description = description!
    }
}
