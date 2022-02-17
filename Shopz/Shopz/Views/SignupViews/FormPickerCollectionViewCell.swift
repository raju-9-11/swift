//
//  FormPickerCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 04/02/22.
//

import UIKit

class FormPickerCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: FormPickerElementDelegate?
    
    static let pickerCellID = "formdropdownpickercellID"
    
    let picker: DropDownWithError = {
        let textField = DropDownWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var errorState: Bool {
        get {
            return picker.errorState
        }
        set {
            picker.errorState = newValue
        }
    }
    
    var pickerProp: DropDownElement? {
        willSet {
            if newValue != nil {
                picker.optionArray = newValue!.optionArray
                self.errorState = newValue!.errorState
                picker.error = newValue!.error
                picker.placeholder = newValue!.placeholder
                picker.text = newValue!.text
            }
            self.setupLayout()
        }
    }
    
    
//    var textFieldProp: TextFieldElement = TextFieldElement(text: "", placeholder: "", error: "", index: -1, type: .plain, tag: "") {
//        willSet {
//            textField.text = newValue.getText()
//            textField.isSecureTextEntry = newValue.getType() == .password ? true : false
//            textField.keyBoardType = newValue.getType() == .number ? .numberPad : newValue.getType() == .email ? .emailAddress : .default
//            textField.error = newValue.getError()
//            textField.errorState = newValue.getErrorState()
//            textField.placeholder = newValue.getPlaceholder()
//            textField.placeholderColor = .darkGray
//            self.setupLayout()
//        }
//    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.picker.text = ""
    }
    
    func setupLayout() {
        
        contentView.addSubview(picker)
        contentView.backgroundColor = .clear
        picker.delegate = self
        NSLayoutConstraint.activate([
            picker.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            picker.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            picker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        picker.makeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        picker.hideList()
        picker.removeFirstResponder()
        return true
    }
}

extension FormPickerCollectionViewCell: DropDownWithErrorDelegate {
    func shouldReturn(_ dropDown: DropDownWithError) {
        guard let pickerProp = pickerProp else { return }
        delegate?.formPickerShouldReturn(dropDown, prop: DropDownElement(optionArray: pickerProp.optionArray, error: pickerProp.error, index: pickerProp.index, errorState: dropDown.errorState, tag: pickerProp.tag, text: dropDown.text, placeholder: pickerProp.placeholder))
    }
    
    func valueChanged(_ dropDown: DropDownWithError, value: String) {
        guard let pickerProp = pickerProp else { return }
        delegate?.formPicker(dropDown, prop: DropDownElement(optionArray: pickerProp.optionArray, error: pickerProp.error, index: pickerProp.index, errorState: dropDown.errorState, tag: pickerProp.tag, text: dropDown.text, placeholder: pickerProp.placeholder))
    }
    
    
    
    
}

protocol FormPickerElementDelegate: AnyObject {
    func formPicker(_ picker: DropDownWithError, prop propChanged: DropDownElement)
    func formPickerShouldReturn(_ picker: DropDownWithError, prop : DropDownElement)
}
