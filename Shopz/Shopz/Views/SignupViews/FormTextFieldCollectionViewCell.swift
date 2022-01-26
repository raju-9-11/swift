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
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.tintColor = UIColor(named: "subtitle_text")
        textField.textColor = UIColor(named: "text_color")
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
    
    var errorState: Bool = false {
        willSet {
            errorLabel.isHidden = !newValue
            textField.layer.borderColor = newValue ? UIColor.red.cgColor : UIColor.systemGray.cgColor
        }
    }
    
    
    var textFieldProp: TextFieldElement = TextFieldElement(text: "", placeholder: "", error: "", index: -1, type: .plain, tag: "") {
        willSet {
            textField.text = newValue.getText()
            textField.isSecureTextEntry = newValue.getType() == .password ? true : false
            textField.keyboardType = newValue.getType() == .number ? .numberPad : newValue.getType() == .email ? .emailAddress : .default
            errorLabel.text = newValue.getError()
            errorState = newValue.getErrorState()
            textField.attributedPlaceholder = NSAttributedString(
                string: newValue.getPlaceholder(),
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray
                ]
            )
            self.setupLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.errorState = false
    }
    
    @objc
    func textFieldEditingChanged(sender: UITextField) {
        let tp = TextFieldElement(text: textField.text ?? textFieldProp.getText(), placeholder: textFieldProp.getPlaceholder(), error: textFieldProp.getError(), index: textFieldProp.getIndex(), type: textFieldProp.getType(), tag: textFieldProp.getTag()
        )
        self.delegate?.notifyChange(textFieldProp: tp)
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
        contentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            textField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            textField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 5),
            errorLabel.rightAnchor.constraint(equalTo: textField.rightAnchor),
        ])
    }
}


protocol TextFormElementDelegate {
    func notifyChange(textFieldProp: TextFieldElement)
    func notifyError(textFieldProp: TextFieldElement)
    func notifyNext(textFieldProp: TextFieldElement)
}
