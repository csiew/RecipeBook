//
//  Genre.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

struct Genre: Identifiable {
    var id: String
    var name: String
    var description: String
    
    init(id: String? = nil, name: String, description: String? = "") {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.description = description!
    }
}
