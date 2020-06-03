//
//  CategoryData.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Combine
import SwiftUI

final class CategoryData: ObservableObject {
    @Published var cuisines: [Cuisine] = sampleCuisines
    @Published var genres: [Genre] = sampleGenres
}
