//
//  SignUpViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class SignUpViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TextFormElementDelegate, SubmitButtonDelegate {
    
    // MARK: - UI Elements
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        return label
    }()
    
    let buttonCellID = "buttonCell"
    let textfieldCellID = "textField"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    var elements:[FormElement] = [TextFieldElement(text: "", placeholder: "Enter Email", error: "Email error", index: 0, type: .email), TextFieldElement(text: "", placeholder: "Enter Password", error: "Password error", index: 1, type: .password), ButtonElement(title: "Sign up", index: 2)]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        collectionView.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: buttonCellID)
        collectionView.register(FormTextFieldCollectionViewCell.self, forCellWithReuseIdentifier: textfieldCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        view.addSubview(collectionView)
        self.setupLayout()
        
    }
    
    
    // MARK: - Delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let buttonElement = elements[indexPath.row] as? ButtonElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCellID, for: indexPath) as! FormButtonCollectionViewCell
            cell.buttonComponentProp = buttonElement
            cell.delegate = self
            return cell
        }
        if let textFieldElement = elements[indexPath.row] as? TextFieldElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textfieldCellID, for: indexPath) as! FormTextFieldCollectionViewCell
            cell.textFieldProp = textFieldElement
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textfieldCellID, for: indexPath) as! FormTextFieldCollectionViewCell
        cell.textFieldProp = TextFieldElement(text: "", placeholder: "", error: "", index: indexPath.row, type: .plain)
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = elements[indexPath.row] as? ButtonElement {
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        return CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    func notifyChange(textFieldProp: TextFieldElement) {
        print("\(textFieldProp.text) at \(textFieldProp.index)")
    }
    
    func notifyError(textFieldProp: TextFieldElement) {
        print("Error Detected at")
    }
    
    func sendSubmit(buttonProp: ButtonElement) {
        (collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! FormTextFieldCollectionViewCell ).errorState = true
        let dict: [String: String] = getFormData()
        for (key, value) in dict {
            print(key, value)
        }
    }
    
    
    func getFormData() -> [String: String] {
        var val: [String: String] = [:]
        _ = elements.map({ element in
            if let elem = element as? TextFieldElement, let field = collectionView.cellForItem(at: IndexPath(row: elem.index, section: 0)) as? FormTextFieldCollectionViewCell {
                val[elem.placeholder] = field.textField.text
            }
        })
        return val
    }
    
    
    @objc
    func onSignup() {
        self.dismiss(animated: true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }

}


class FormElement {
    var id = UUID()
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
    
    init( text: String, placeholder: String, error: String, index: Int, type: FieldType) {
        self.index = index
        self.text = text
        self.placeholder = placeholder
        self.error = error
        self.type = type
    }
}

enum FieldType {
    case email, password, number, plain
}
