//
//  TextFieldWithError.swift
//  Shopz
//
//  Created by Rajkumar S on 20/01/22.
//

import UIKit

class TextFieldWithError: UIView, UITextFieldDelegate {
    
    weak var delegate: TextFieldWithErrorDelegate?
    
    var maxLength: Int?
    
    var borderStyle: UITextField.BorderStyle {
        get {
            return textField.borderStyle
        }
        set {
            textField.borderStyle = newValue
        }
    }
    
    var font: UIFont {
        get {
            return textField.font ?? .systemFont(ofSize: 12)
        } set {
            textField.font = newValue
        }
    }
    
    var textMask: String? {
        willSet {
            if newValue != nil {
                self.maxLength = newValue!.count
            }
        }
    }
    
    var keyBoardType: UIKeyboardType {
        get {
            return textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    var autoCorrection: UITextAutocorrectionType {
        get {
            return textField.autocorrectionType
        }
        set {
            textField.autocorrectionType = newValue
        }
    }
    
    var autoCapitalize: UITextAutocapitalizationType {
        get {
            return textField.autocapitalizationType
        }
        set {
            textField.autocapitalizationType = newValue
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
            eyeIcon.isHidden = !newValue
        }
    }
    
    private let eyeIcon: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.appTextColor
        button.setContentMode(mode: .scaleAspectFit)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    var placeholder: String = "" {
        willSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: newValue,
                attributes: [
                    NSAttributedString.Key.foregroundColor: placeholderColor
                ]
            )
        }
    }
    
    var placeholderColor: UIColor = .darkGray {
        willSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: textField.placeholder ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: newValue
                ]
            )
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

    private let textField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.tintColor = UIColor.subtitleTextColor
        textField.textColor = UIColor.appTextColor
        textField.backgroundColor = .clear
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
        self.addSubview(eyeIcon)
        textField.delegate = self
        textField.addTarget(self, action: #selector(onChange), for: .editingChanged)
        eyeIcon.addTarget(self, action: #selector(onEyeClick), for: .touchUpInside)
        self.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            eyeIcon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeIcon.rightAnchor.constraint(equalTo: textField.rightAnchor, constant: -5),
            eyeIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            eyeIcon.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            errorLabel.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 5),
        ])
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.textField.addTarget(target, action: action, for: controlEvents)
    }
    
    @objc
    func onEyeClick() {
        textField.isSecureTextEntry.toggle()
        eyeIcon.setImage(!textField.isSecureTextEntry ? UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @objc
    func onChange(_ textField: UITextField) {
        guard let textMask = textMask else {
            if keyBoardType == .numberPad {
                text = text.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            }
            return
        }
        text = text.applyPatternOnNumbers(pattern: textMask)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        guard let maxLength = maxLength else {
            return true
        }
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.shouldReturn(self)
        return true
    }

}

extension String {
    func applyPatternOnNumbers(pattern: String) -> String {
            let replacmentCharacter: Character = "#"
            var pure = self.replacingOccurrences( of: "[^۰-۹0-9]", with: "", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pure.count else { return pure }
                let stringIndex = String.Index(utf16Offset: index, in: pattern)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacmentCharacter else { continue }
                pure.insert(patternCharacter, at: stringIndex)
            }
           return pure
        }
}

protocol TextFieldWithErrorDelegate: AnyObject {
    func shouldReturn(_ textField: TextFieldWithError)
}
