//
//  SignUpViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class SignUpViewController: CustomViewController {
    
    // MARK: - UI Elements
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "background_color")
        view.layer.cornerRadius = 10
        return view
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = UIColor(named: "text_color")
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
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.buttonCellID)
        cv.register(FormTextFieldCollectionViewCell.self, forCellWithReuseIdentifier: FormTextFieldCollectionViewCell.textfieldCellID)
        cv.register(FormPickerCollectionViewCell.self, forCellWithReuseIdentifier: FormPickerCollectionViewCell.pickerCellID)
        cv.register(FormSignInCollectionViewCell.self, forCellWithReuseIdentifier: FormSignInCollectionViewCell.plainCellID)
        return cv
    }()
    
    
    lazy var elements:[Int: FormElement] = [
        0: TextFieldElement(text: "", placeholder: "Enter first name", error: "First name cannot be empty", index: 0, type: .plain, tag: "fname") ,
        1: TextFieldElement(text: "", placeholder: "Enter last name", error: "Last name cannot be empty", index: 1, type: .plain, tag: "lname") ,
        2: TextFieldElement(text: "", placeholder: "Enter Email", error: "Email cannot be empty", index: 2, type: .email, tag: "email"),
        3: TextFieldElement(text: "", placeholder: "Enter Password", error: "Password should contain atleast 8 characters", index: 3, type: .password, tag: "cpassword"),
        4: TextFieldElement(text: "", placeholder: "Confirm Password", error: "Password should contain atleast 8 characters", index: 4, type: .password, tag: "password"),
        5: DropDownElement(optionArray: StorageDB.getCountries().map({ return $0.country }), error: "Enter valid country name", index: 5, errorState: false, tag: "country", text: "", placeholder: "Enter Country"),
        6: DropDownElement(optionArray: [], error: "Enter valid state", index: 6, errorState: false, tag: "state", text: "", placeholder: "Enter State"),
        
        7: TextFieldElement(text: "", placeholder: "Enter City", error: "City cannot be empty", index: 7, type: .plain, tag: "city"),
        8: ButtonElement(title: "Sign up", index: 8),
        9: PlainElement(index: 9)
        
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func setupLayout() {
        view.backgroundColor = .systemGray
        
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

extension SignUpViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        case let item as DropDownElement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FormPickerCollectionViewCell.pickerCellID, for: indexPath) as! FormPickerCollectionViewCell
            cell.pickerProp = item
            cell.delegate = self
            return cell
        case _ as PlainElement:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSignInCollectionViewCell.plainCellID, for: indexPath) as! FormSignInCollectionViewCell
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
            return CGSize(width: item.getIndex() < 2 ? collectionView.frame.width*0.45 : collectionView.frame.width, height: 70)
        case _ as ButtonElement:
            return CGSize(width: collectionView.frame.width, height: 50)
        default:
            return CGSize(width: collectionView.frame.width, height: 70)
        }
    }
}

extension SignUpViewController: TextFormElementDelegate, SubmitButtonDelegate, SignInFormCellDelegate, FormPickerElementDelegate {
    
    func notifyChange(textFieldProp: TextFieldElement) {
        (elements[textFieldProp.getIndex()] as? TextFieldElement)?.setText(text: textFieldProp.getText())
    }
    
    func formPicker(_ picker: DropDownWithError, prop propChanged: DropDownElement) {
        if let dropDown = elements[propChanged.index] as? DropDownElement {
            dropDown.text = propChanged.text
            if dropDown.index == 5 {
                (elements[6] as? DropDownElement)?.optionArray = StorageDB.getStates(country: propChanged.text)
                collectionView.reloadItems(at: [IndexPath(row: 6, section: 0)])
            }
        }
    }
    
    func formPickerShouldReturn(_ picker: DropDownWithError, prop: DropDownElement) {
        if prop.index != (elements[elements.count - 2] as? DropDownElement)?.index {
            collectionView.scrollToItem(at: IndexPath(row: prop.index + 1, section: 0), at: .top, animated: true)
            _ = (collectionView.cellForItem(at: IndexPath(row: prop.index, section: 0)) as? FormPickerCollectionViewCell)?.resignFirstResponder()
            _ = (collectionView.cellForItem(at: IndexPath(row: prop.index + 1, section: 0)) as? FormTextFieldCollectionViewCell)?.becomeFirstResponder()
            _ = (collectionView.cellForItem(at: IndexPath(row: prop.index + 1, section: 0)) as? FormPickerCollectionViewCell)?.becomeFirstResponder()
        } else {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func sendSubmit(buttonProp: ButtonElement) {
        let formData = getFormData()
        let dict: [String: String] = formData.values
        if formData.error {
            Toast.shared.showToast(message: "Errors Found", type: .error)
            return
        } else {
            if let fname = dict["fname"],
               let lname = dict["lname"],
               let email = dict["email"],
               let country = dict["country"],
               let city = dict["city"],
               let password = dict["password"],
               let state = dict["state"],
               ApplicationDB.shared.addUser(firstName: fname, lastName: lname, email: email, ph: "", country: country, stateName: state, city: city, password: password) {
                Toast.shared.showToast(message: "User Created", type: .success)
                self.onSignup()
            }
        }
    }
    
    func notifyNext(textFieldProp: TextFieldElement) {
        if textFieldProp.getIndex() != (elements[elements.count - 2] as? TextFieldElement)?.getIndex() {
            collectionView.scrollToItem(at: IndexPath(row: textFieldProp.getIndex() + 1, section: 0), at: .top, animated: true)
            _ = (collectionView.cellForItem(at: IndexPath(row: textFieldProp.getIndex(), section: 0)) as? FormTextFieldCollectionViewCell)?.resignFirstResponder()
            _ = (collectionView.cellForItem(at: IndexPath(row: textFieldProp.getIndex() + 1, section: 0)) as? FormTextFieldCollectionViewCell)?.becomeFirstResponder()
            _ = (collectionView.cellForItem(at: IndexPath(row: textFieldProp.getIndex() + 1, section: 0)) as? FormPickerCollectionViewCell)?.becomeFirstResponder()
        } else {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func getFormData() -> (error: Bool, values: [String: String]) {
        var val : [String: String] = [:]
        var error: Bool = false
        self.elements.forEach({ index,element in
            if let elem = element as? TextFieldElement {
                if elem.checkError() {
                    error = true
                }
                val[elem.getTag()] = elem.getText()
            }
            if let elem = element as? DropDownElement {
                if elem.checkError() {
                    error = true
                }
                val[elem.tag] = elem.text
            }
        })
        if !(elements[3] as! TextFieldElement).isSamePassword(asElem: elements[4] as! TextFieldElement) {
            error = true
        }
        self.collectionView.reloadData()
        return (error: error, values: val)
    }
    
    func onSignup() {
        self.dismiss(animated: true)
    }
    
    func sendSignIn() {
        self.dismiss(animated: true, completion: nil)
    }
}
