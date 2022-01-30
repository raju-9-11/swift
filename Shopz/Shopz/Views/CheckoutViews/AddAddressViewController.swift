//
//  AddAddressViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 30/01/22.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    weak var delegate: AddAddressDelegate?
    
    let backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "background_color")
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter new address"
        label.font = .monospacedSystemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLine1: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter address Line one"
        textField.error = "Address cannot be empty"
        return textField
    }()
    
    let addressLine2: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter address Line two"
        textField.error = "Address cannot be empty"
        return textField
    }()
    
    let country: DropDownWithError = {
        let textField = DropDownWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Country"
        textField.error = "Invalid country"
        return textField
    }()
    
    let city: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter City"
        textField.error = "City cannot be empty"
        return textField
    }()
    
    let pincode: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter pincode"
        textField.keyBoardType = .numberPad
        textField.error = "Pincode cannot be empty"
        return textField
    }()
    
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLine1, addressLine2, country, city, pincode, button])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Add Address", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .clear

        containerView.addSubview(stackView)
        
        button.addTarget(self, action: #selector(onAddAddress), for: .touchUpInside)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextDismiss)))
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1.3),
        ])
        
        country.optionArray = getCountriesName()
        country.optionImageArray = getCountriesFlags()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getCountriesFlags() -> [String] {
        var countriesData = [String]()

        for code in NSLocale.isoCountryCodes  {
            let flag = String.emojiFlag(for: code)
            countriesData.append(flag!)
        }

        return countriesData
    }
    
    func getCountriesName() -> [String] {
        var countriesData = [String]()

        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])

            if let name = NSLocale(localeIdentifier: "en_IN").displayName(forKey: NSLocale.Key.identifier, value: id) {
                countriesData.append(name)
            }
        }

        return countriesData
    }
    
    @objc
    func onAddAddress() {
        addressLine1.errorState = addressLine1.text.isEmpty
        addressLine2.errorState = addressLine2.text.isEmpty
        pincode.errorState = pincode.text.isEmpty
        city.errorState = city.text.isEmpty
        country.errorState = country.text.isEmpty
        if addressLine1.text.isEmpty || addressLine2.text.isEmpty || pincode.text.isEmpty || city.text.isEmpty || country.errorState || country.text.isEmpty {
            return
        }
        delegate?.addAddressClick(Address(addressLine1: addressLine1.text, addressLine2: addressLine2.text, pincode: pincode.text, city: city.text, country: country.text, addressId: -1, userId: Auth.auth?.user.id ?? -1))
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc
    func onKeyboardShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint?.constant = -120
    }
    
    @objc
    func onKeyboardHide(notification: Notification) {
        bottomConstraint?.constant = 0
    }
    
    @objc
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func onTextDismiss() {
        self.containerView.endEditing(true)
    }

}


protocol AddAddressDelegate: AnyObject {
    func addAddressClick(_ address: Address)
}

extension String {
    static func emojiFlag(for countryCode: String) -> String! {
        func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
            return scalar.value >= 0x61 && scalar.value <= 0x7A
        }

        func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowercaseASCIIScalar(scalar))

            // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
            // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
            return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))!
        }

        let lowercasedCode = countryCode.lowercased()
        guard lowercasedCode.count == 2 else { return nil }
        guard lowercasedCode.unicodeScalars.reduce(true, { accum, scalar in accum && isLowercaseASCIIScalar(scalar) }) else { return nil }

        let indicatorSymbols = lowercasedCode.unicodeScalars.map({ regionalIndicatorSymbol(for: $0) })
        return String(indicatorSymbols.map({ Character($0) }))
    }
}
