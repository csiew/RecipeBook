//
//  TextFieldWithLabel.swift
//  Recipe Book
//
//  Created by Clarence Siew on 4/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct TextFieldWithLabel: View {
    @Binding var text: String
    var label: String
    
    var body: some View {
        VStack {
            Text(self.label)
                .bold()
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding([.top, .leading, .trailing], 8)
            TextField(self.label, text: self.$text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.bottom, 8)
    }
}

struct TextFieldWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(text: .constant("Testing testing"), label: "Test Text Field")
    }
}
