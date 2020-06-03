//
//  CuisineList.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct CuisineList: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var categoryData: CategoryData
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        List {
            ForEach(self.categoryData.cuisines, id: \.self.id) { cuisine in
                NavigationLink(cuisine.name, destination: CuisineListDetail(cuisine: cuisine))
            }
        }
        .navigationBarTitle("Cuisines", displayMode: .inline)
    }
}

struct CuisineList_Previews: PreviewProvider {
    static var previews: some View {
        CuisineList()
            .environmentObject(UserSettings())
            .environmentObject(CategoryData())
            .environmentObject(UserData())
    }
}
