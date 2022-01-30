//
//  AddNewCardViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 25/01/22.
//

import UIKit

class AddNewCardViewController: UIViewController {
    
    weak var delegate: AddCardDelegate?
    
    lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, cardNumberField, nameField, validityDate, addButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        view.contentMode = .center
        view.backgroundColor = .clear
        return view
    }()
    
    let maskView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        return view
    }()
    
    let backGroundView: UIView = {
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
        button.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        
        view.addSubview(backGroundView)
        view.addSubview(containerView)
        addButton.addTarget(self, action: #selector(onAddCard), for: .touchUpInside)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTextDismiss)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint?.isActive = true
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    func onTextDismiss() {
        self.containerView.endEditing(true)
    }
    
    @objc
    func onAddCard() {
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
        guard let date = dateFormatter.date(from: dateString), (date.months(from: Date()) > 0 && date.years(from: Date()) >= 0 )  else {
            validityDate.errorState = true
            return
        }
        delegate?.onAddClick(name: nameField.text, cardNumber: cardNumberField.text, date: date)
        self.onDismiss()
    }
    
    @objc
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

protocol AddCardDelegate: AnyObject {
    func onAddClick(name: String, cardNumber: String, date: Date)
}
