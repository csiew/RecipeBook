//
//  DetailCellView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct DetailCellView: View {
    var title: Text
    var detail: Text?
    var customIcon: UIImage?
    var systemIcon: String?
    
    var body: some View {
        Rectangle()
            .fill(Color.init(.sRGB, red: 255, green: 255, blue: 255, opacity: 0.00000000001))
            .overlay(
                HStack {
                    self.title
                    Spacer()
                    if self.detail != nil {
                        self.detail!
                    } else if self.customIcon != nil {
                        Image(uiImage: self.customIcon!)
                    } else if self.systemIcon != nil {
                        Image(systemName: self.systemIcon!)
                    }
                }
            )
    }
}


struct DetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCellView(title: Text("Cell Title"), detail: Text("Detail"))
    }
}
