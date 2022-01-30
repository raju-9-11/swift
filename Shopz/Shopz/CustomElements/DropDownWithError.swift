//
//  DropDownWithError.swift
//  Shopz
//
//  Created by Rajkumar S on 30/01/22.
//

import UIKit

class DropDownWithError: UIView {
    
    var borderStyle: UITextField.BorderStyle {
        get {
            return textField.borderStyle
        }
        set {
            textField.borderStyle = newValue
        }
    }
    
    var optionArray: [String] {
        get {
            return self.textField.optionArray
        }
        set {
            self.textField.optionArray = newValue
        }
    }
    
    var optionImageArray: [String] {
        get {
            return self.textField.optionImageArray
        }
        set {
            self.textField.optionImageArray = newValue
        }
    }
    
    var font: UIFont {
        get {
            return textField.font ?? .systemFont(ofSize: 12)
        } set {
            textField.font = newValue
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

    private let textField: DropDown = {
        let textField = DropDown()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorLabel: UILabel = {
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
        self.addSubview(errorLabel)
        
        textField.customDelegate = self
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 5),
        ])
    }

}

extension DropDownWithError: DropDownDelegate {
    func dropDownShouldReturn(_ dropDown: DropDown) {
        dropDown.resignFirstResponder()
        dropDown.hideList()
    }
    
    func endEditing(_ dropDown: DropDown) {
        self.errorState = dropDown.selectedIndex == nil
        dropDown.hideList()
    }
    
    func beginEditing(_ dropDown: DropDown) {
        dropDown.showList()
    }
    
    func dropDown(_ dropDown: DropDown, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func dropDown(_ dropDown: DropDown, didSelectItemAt item: Int) {
        self.errorState = false
    }
    
    
}
