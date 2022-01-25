//
//  TextViewWithPlaceholder.swift
//  Shopz
//
//  Created by Rajkumar S on 23/01/22.
//

import UIKit

class TextViewWithPlaceHolder: UITextView, UITextViewDelegate {
    
    
    var placeholderColor: UIColor? = .lightGray
    var textViewTextColor: UIColor = .black
    
    var placeholder: String = "" {
        willSet {
            if text.isEmpty {
                text = newValue
                textColor = placeholderColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = textViewTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
}

