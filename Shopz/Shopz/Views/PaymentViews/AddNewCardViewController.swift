//
//  AddNewCardViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 25/01/22.
//

import UIKit

class AddNewCardViewController: CustomViewController {
    
    let containerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        view.contentMode = .center
        view.backgroundColor = .clear
        return view
    }()
    
    let backGroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter Card Details"
        return label
    }()
    
    let cardNumberField: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        textField.placeholder = "Enter Card Number"
        textField.textMask = "#### - #### - #### - ####"
        textField.error = "Card should contain 16 numbers"
        textField.keyBoardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameField: TextFieldWithError = {
        let textField = TextFieldWithError()
        textField.placeholder = "Enter name on card"
        textField.error = "Name cannot be empty"
        textField.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let validityDate: TextFieldWithError = {
       let textField = TextFieldWithError()
        textField.placeholder = "MM/YYYY"
        textField.error = "Enter valid date"
        textField.textMask = "## / ####"
        textField.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Card", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        self.setupLayout()
    }
    
    override func setupLayout() {
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(cardNumberField)
        containerView.addArrangedSubview(nameField)
        containerView.addArrangedSubview(validityDate)
        containerView.addArrangedSubview(addButton)
        view.addSubview(backGroundView)
        view.addSubview(containerView)
        addButton.addTarget(self, action: #selector(onAddCard), for: .touchUpInside)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextDismiss)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            backGroundView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            backGroundView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            backGroundView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1.2),
            backGroundView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.2)
        ])
    }
    
    @objc
    func onTextDismiss() {
        self.containerView.endEditing(true)
        print("Tap")
    }
    
    @objc
    func onAddCard() {
        if let vc = self.parent as? PaymentViewController {
            if nameField.text.isEmpty || cardNumberField.text.isEmpty || cardNumberField.text.count != cardNumberField.textMask!.count || validityDate.text.count != validityDate.textMask!.count || validityDate.text.isEmpty {
                nameField.errorState = nameField.text.isEmpty
                cardNumberField.errorState = cardNumberField.text.isEmpty || cardNumberField.text.count != cardNumberField.textMask!.count
                validityDate.errorState = validityDate.text.count != validityDate.textMask!.count || validityDate.text.isEmpty
                return
            }
            nameField.errorState = false
            cardNumberField.errorState = false
            validityDate.errorState = false
            let dateString = validityDate.text.replacingOccurrences(of: " ", with: "")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            dateFormatter.locale = .current
            guard let _ = dateFormatter.date(from: dateString) else {
                validityDate.errorState = true
                return
            }
            vc.onAddCard(name: nameField.text, cardNumber: cardNumberField.text, date: validityDate.text)
            self.onDismiss()
        }
    }
    
    @objc
    func onDismiss() {
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
