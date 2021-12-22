//
//  SignUpViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class SignUpViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, TextFormElementDelegate, SubmitButtonDelegate, SignInFormCellDelegate {
    
    // MARK: - UI Elements
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        return label
    }()
    
    
    var collectionViewBottomConstraint: NSLayoutConstraint?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.buttonCellID)
        cv.register(FormTextFieldCollectionViewCell.self, forCellWithReuseIdentifier: FormTextFieldCollectionViewCell.textfieldCellID)
        cv.register(FormSignInCollectionViewCell.self, forCellWithReuseIdentifier: FormSignInCollectionViewCell.buttonCellID)
        return cv
    }()
    
    
    var elements:[FormElement] = [
        TextFieldElement(text: "", placeholder: "Enter first name", error: "Name Error", index: 0, type: .plain, tag: "name") ,
        TextFieldElement(text: "", placeholder: "Enter last name", error: "Name Error", index: 1, type: .plain, tag: "name") ,
        TextFieldElement(text: "", placeholder: "Enter Email", error: "Email error", index: 2, type: .email, tag: "email"),
        TextFieldElement(text: "", placeholder: "Enter Password", error: "Password error", index: 3, type: .password, tag: "password"),
        TextFieldElement(text: "", placeholder: "Confirm Password", error: "Password error", index: 4, type: .password, tag: "password"),
        TextFieldElement(text: "", placeholder: "Enter Country", error: "Country error", index: 5, type: .plain, tag: "country"),
        TextFieldElement(text: "", placeholder: "Enter City", error: "City error", index: 6, type: .plain, tag: "city"),
        ButtonElement(title: "Sign up", index: 4),
        PlainElement()
        
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch(elements[indexPath.row]) {
        case let item as TextFieldElement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextFieldCollectionViewCell.textfieldCellID, for: indexPath) as! FormTextFieldCollectionViewCell
            cell.textFieldProp = item
            cell.delegate = self
            return cell
        case let item as ButtonElement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FormButtonCollectionViewCell.buttonCellID, for: indexPath) as! FormButtonCollectionViewCell
            cell.buttonComponentProp = item
            cell.delegate = self
            return cell
        case _ as PlainElement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSignInCollectionViewCell.buttonCellID, for: indexPath) as! FormSignInCollectionViewCell
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch(elements[indexPath.row]) {
        case let item as TextFieldElement:
            return CGSize(width: item.index < 2 ? collectionView.frame.width*0.45 : collectionView.frame.width, height: 70)
        case _ as ButtonElement:
            return CGSize(width: collectionView.frame.width, height: 50)
        default:
            return CGSize(width: collectionView.frame.width, height: 70)
        }
    }
    
    func notifyChange(textFieldProp: TextFieldElement) {
        elements[textFieldProp.index] = textFieldProp
    }
    
    func notifyError(textFieldProp: TextFieldElement) {
        print("Error Detected at")
    }
    
    func sendSubmit(buttonProp: ButtonElement) {
//        (collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? FormTextFieldCollectionViewCell )?.errorState = true
        let dict: [String: String] = getFormData()
        for (key, value) in dict {
            print(key, value)
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        self.onSignup()
    }
    
    func notifyNext(textFieldProp: TextFieldElement) {
        collectionView.scrollToItem(at: IndexPath(row: textFieldProp.index, section: 0), at: .top, animated: true)
        if textFieldProp.index != (elements[elements.count - 2] as? TextFieldElement)?.index {
            (collectionView.cellForItem(at: IndexPath(row: textFieldProp.index, section: 0)) as? FormTextFieldCollectionViewCell)?.textField.resignFirstResponder()
            (collectionView.cellForItem(at: IndexPath(row: textFieldProp.index + 1, section: 0)) as? FormTextFieldCollectionViewCell)?.textField.becomeFirstResponder()
        }
    }
    
    
    func getFormData() -> [String: String] {
        var val: [String: String] = [:]
        _ = elements.map({ element in
            if let elem = element as? TextFieldElement {
                val[elem.tag] = elem.text
            } 
        })
        return val
    }
    
    func onSignup() {
        self.dismiss(animated: true)
    }
    
    func sendSignIn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        self.collectionViewBottomConstraint?.constant  = -(keyBoardFrame?.height ?? 0)
    }
    
    @objc
    func keyboardWillHideNotification(notification: NSNotification) {
        self.collectionViewBottomConstraint?.constant = 0
    }
    
    override func setupLayout() {
        view.backgroundColor = .systemGray6
        
        collectionView.delegate = self
        collectionView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(containerView)
        containerView.addSubview(signUpLabel)
        containerView.addSubview(collectionView)
        
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        collectionViewBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            signUpLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            collectionView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
        ])
    }

}

class FormElement: Hashable {
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormElement, rhs: FormElement) -> Bool {
        lhs.id == rhs.id
    }
}

class FormElementSection: Hashable {
    var id = UUID()
    var items: [FormElement]
    
    init(items: [FormElement]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FormElementSection, rhs: FormElementSection) -> Bool {
        lhs.id == rhs.id
    }
}

class ButtonElement: FormElement {
    var title: String
    var index: Int
    
    init(title: String, index: Int) {
        self.index = index
        self.title = title
    }
}

class TextFieldElement: FormElement {
    var placeholder: String
    var text: String
    var error: String
    var index: Int
    var type: FieldType
    var tag: String
    var errorState: Bool = false
    
    init( text: String, placeholder: String, error: String, index: Int, type: FieldType, tag: String) {
        self.index = index
        self.text = text
        self.placeholder = placeholder
        self.error = error
        self.type = type
        self.tag = tag
    }
}

class PlainElement: FormElement{
    
}

enum FieldType {
    case email, password, number, plain
}
