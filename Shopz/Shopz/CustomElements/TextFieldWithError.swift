//
//  TextFieldWithError.swift
//  Shopz
//
//  Created by Rajkumar S on 20/01/22.
//

import UIKit

class TextFieldWithError: UIView, UITextFieldDelegate {
    
    weak var delegate: TextFieldWithErrorDelegate?
    
    var borderStyle: UITextField.BorderStyle {
        get {
            return textField.borderStyle
        }
        set {
            textField.borderStyle = newValue
        }
    }
    
    var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    
    var isSecureTextEntry: Bool = false {
        willSet {
            textField.isSecureTextEntry = newValue
        }
    }
    
    var placeholder: String = "" {
        willSet {
            textField.placeholder = newValue
        }
    }
    
    var error: String = "" {
        willSet {
            errorLabel.text = newValue
        }
    }
    
    var errorState: Bool = false {
        willSet {
            errorLabel.isHidden = !newValue
            textField.layer.borderColor = newValue ? UIColor.red.cgColor : UIColor.systemGray.cgColor
        }
    }

    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.tintColor = .darkGray
        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.contentMode = .top
        label.sizeToFit()
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "Error"
        label.isHidden = true
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    func removeFirstResponder() {
        textField.resignFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(textField)
        textField.delegate = self
        self.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 5),
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.shouldReturn(self)
        return true
    }

}

protocol TextFieldWithErrorDelegate: AnyObject {
    func shouldReturn(_ textField: TextFieldWithError)
}
