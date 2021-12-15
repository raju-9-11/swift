//
//  FormTextFieldCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import UIKit

class FormTextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    static let textfieldCellID = "textField"
    
    var delegate: TextFormElementDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 6
        return textField
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.contentMode = .top
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "Error"
        label.isHidden = true
        return label
    }()
    
    var errorState: Bool = false {
        willSet {
            errorLabel.isHidden = !newValue
            textField.layer.borderColor = newValue ? UIColor.red.cgColor : UIColor.systemGray.cgColor
            textFieldProp.errorState = newValue
        }
    }
    
    
    var textFieldProp: TextFieldElement = TextFieldElement(text: "", placeholder: "", error: "", index: -1, type: .plain, tag: "") {
        willSet {
            textField.text = newValue.text
            if newValue.type == .password {
                textField.isSecureTextEntry = true
            }
            if newValue.type == .number {
                textField.keyboardType = .numberPad
            }
            if newValue.type == .email {
                textField.keyboardType = .emailAddress
            }
            errorLabel.text = newValue.error
            errorState = newValue.errorState
            textField.placeholder = newValue.placeholder
            self.setupLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    @objc
    func textFieldEditingChanged(sender: UITextField) {
        let tp = TextFieldElement(text: textField.text ?? textFieldProp.text, placeholder: textFieldProp.placeholder, error: textFieldProp.error, index: textFieldProp.index, type: textFieldProp.type, tag: textFieldProp.tag)
        tp.errorState = self.errorState
        self.delegate?.notifyChange(textFieldProp: tp)
    }
    
    func checkError() -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.notifyNext(textFieldProp: textFieldProp)
        return true
    }
    
    func setupLayout() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .allEditingEvents)
        
        contentView.addSubview(textField)
        contentView.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 5),
        ])
    }
    
}


protocol TextFormElementDelegate {
    
    func notifyChange(textFieldProp: TextFieldElement)
    func notifyError(textFieldProp: TextFieldElement)
    func notifyNext(textFieldProp: TextFieldElement)
}
