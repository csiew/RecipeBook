//  Based on:
//      MultilineTextView by sas and George_E
//          https://stackoverflow.com/a/56549250

import SwiftUI
import Combine

struct MultilineTextField: UIViewRepresentable {
    @Binding var text: String
    @State var isFirstResponder: Bool = false

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.systemFont(ofSize: 17)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        if self.isFirstResponder == true {
            view.becomeFirstResponder()
        }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextField
        
        init(_ parent: MultilineTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
