//  Based on:
//      MultilineTextView by sas and George_E
//          https://stackoverflow.com/a/56549250

import SwiftUI
import Combine

struct MultilineTextField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.systemFont(ofSize: 17)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
