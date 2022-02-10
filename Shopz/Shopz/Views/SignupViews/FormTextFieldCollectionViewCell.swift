//
//  FormTextFieldCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import UIKit

class FormTextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    static let textfieldCellID = "formtextFieldcellID"
    
    var delegate: TextFormElementDelegate?
    
    let textField: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var errorState: Bool {
        get {
            return textField.errorState
        }
        set {
            textField.errorState = newValue
        }
    }
    
    
    var textFieldProp: TextFieldElement = TextFieldElement(text: "", placeholder: "", error: "", index: -1, type: .plain, tag: "") {
        willSet {
            textField.text = newValue.getText()
            textField.isSecureTextEntry = newValue.getType() == .password ? true : false
            textField.keyBoardType = newValue.getType() == .number ? .numberPad : newValue.getType() == .email ? .emailAddress : .default
            textField.error = newValue.getError()
            textField.errorState = newValue.getErrorState()
            textField.placeholder = newValue.getPlaceholder()
            textField.placeholderColor = .darkGray
            self.setupLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.errorState = false
    }
    
    @objc
    func textFieldEditingChanged() {
        let tp = TextFieldElement(text: textField.text, placeholder: textFieldProp.getPlaceholder(), error: textFieldProp.getError(), index: textFieldProp.getIndex(), type: textFieldProp.getType(), tag: textFieldProp.getTag()
        )
        self.delegate?.notifyChange(textFieldProp: tp)
    }
    
    func setupLayout() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .allEditingEvents)
        contentView.addSubview(textField)
        contentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.textField.makeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.textField.removeFirstResponder()
        return true
    }
}

extension FormTextFieldCollectionViewCell: TextFieldWithErrorDelegate {
    func shouldReturn(_ textField: TextFieldWithError) {
        delegate?.notifyNext(textFieldProp: textFieldProp)
    }
}


protocol TextFormElementDelegate {
    func notifyChange(textFieldProp: TextFieldElement)
    func notifyNext(textFieldProp: TextFieldElement)
}
