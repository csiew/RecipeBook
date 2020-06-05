//
//  GenreList.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct GenreList: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var categoryData: CategoryData
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        List {
            ForEach(self.categoryData.genres, id: \.self.id) { genre in
                NavigationLink(genre.name, destination: GenreListDetail(genre: genre))
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Genres", displayMode: .inline)
    }
}

struct GenreList_Previews: PreviewProvider {
    static var previews: some View {
        GenreList()
    }
}
