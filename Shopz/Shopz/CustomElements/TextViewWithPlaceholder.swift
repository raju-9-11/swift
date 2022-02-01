//
//  TextViewWithPlaceholder.swift
//  Shopz
//
//  Created by Rajkumar S on 23/01/22.
//

import UIKit

class TextViewWithPlaceHolder: UIView, UITextViewDelegate {
    
    var isEditing: Bool = false
    
    var isEnabled: Bool = true {
        willSet {
            if newValue {
                textField.layer.borderWidth = 1
            } else {
                textField.layer.borderWidth = 0
            }
            textField.isSelectable = newValue
            textField.isScrollEnabled = newValue
            textField.isEditable = newValue
        }
    }
    
    var customBackgroundColor: UIColor? {
        get {
            return self.textField.backgroundColor
        }
        set {
            self.textField.backgroundColor = newValue
        }
    }
    
    
    var placeholderColor: UIColor? = UIColor(named: "subtitle_text") {
        willSet {
            if textField.textColor == placeholderColor {
                textField.textColor = newValue
            }
        }
    }
    
    var textViewTextColor: UIColor? = UIColor(named: "text_color") {
        willSet {
            if textField.textColor == textViewTextColor {
                textField.textColor = newValue
            }
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return textField.textAlignment
        }
        set {
            textField.textAlignment = newValue
        }
    }
    
    var font: UIFont? {
        get {
            return textField.font
        }
        set {
            textField.font = newValue
        }
    }
    
    var isEditable: Bool {
        get {
            return textField.isEditable
        }
        set {
            textField.isEditable = newValue
        }
    }
    
    var contentInset: UIEdgeInsets {
        get {
            return textField.contentInset
        }
        set {
            textField.contentInset = newValue
        }
    }
    
    var text: String {
        get {
            if textField.textColor == textViewTextColor {
                return textField.text
            }
            return ""
        }
        set {
            self.textField.text = newValue
            if newValue.isEmpty {
                textField.text = placeholder
                textField.textColor = placeholderColor
            } else {
                textField.textColor = textViewTextColor
            }
        }
    }
    
    var isSelectable: Bool {
        get {
            return textField.isSelectable
        }
        set {
            textField.isSelectable = newValue
        }
    }
    
    private let textField: UITextView = {
        let textview = UITextView()
        textview.layer.cornerRadius = 6
        textview.textColor =  UIColor(named: "text_color")
        textview.layer.borderColor = UIColor.darkGray.cgColor
        textview.layer.borderWidth = 1
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    func removeBorder() {
        self.textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    var placeholder: String = "" {
        willSet {
            if let text = textField.text, text.isEmpty {
                textField.text = newValue
                textField.textColor = placeholderColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        textField.delegate = self
        
        
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    func makeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = textViewTextColor
        }
        isEditing = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
        isEditing = false
    }
}

