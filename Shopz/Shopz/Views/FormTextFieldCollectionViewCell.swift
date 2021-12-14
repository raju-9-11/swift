//
//  FormTextFieldCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import UIKit

class FormTextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
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
        }
    }
    
    
    var textFieldProp: TextFieldElement = TextFieldElement(text: "", placeholder: "", error: "", index: -1, type: .plain) {
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
            textField.placeholder = newValue.placeholder
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        
        contentView.addSubview(textField)
        contentView.addSubview(errorLabel)
        self.setupLayout()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.notifyChange(textFieldProp: TextFieldElement(text: textField.text ?? textFieldProp.text, placeholder: textFieldProp.placeholder, error: textFieldProp.error, index: textFieldProp.index, type: textFieldProp.type))
    }
    
    func errorDetected(for: FieldType, text: String) -> Bool {
        return false
    }
    
    func setupLayout() {
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
}
