//
//  ProfileEditViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 02/02/22.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    let maskView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(named: "background_color")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let profileImage: RoundedImage = {
        let imageView = RoundedImage()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(FormButtonCollectionViewCell.self, forCellWithReuseIdentifier: FormButtonCollectionViewCell.buttonCellID)
        cv.register(FormTextFieldCollectionViewCell.self, forCellWithReuseIdentifier: FormTextFieldCollectionViewCell.textfieldCellID)
        cv.register(FormPickerCollectionViewCell.self, forCellWithReuseIdentifier: FormPickerCollectionViewCell.pickerCellID)
        return cv
    }()
    
    var collectionViewBottomConstraint: NSLayoutConstraint?
    
    var elements:[Int: FormElement] = [:]
    
    var profileURL: URL? {
        willSet {
            if newValue != nil {
                do {
                    profileImage.image = try UIImage(data: Data(contentsOf: newValue!))
                }
                catch {
                    print(error)
                }
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageClick)))
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(maskView)
        view.addSubview(containerView)
        containerView.addSubview(profileImage)
        containerView.addSubview(collectionView)
        
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        collectionViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 5),
            collectionView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            collectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            
            profileImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileImage.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            profileImage.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
        ])
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func loadData() {
        guard let user = Auth.auth?.user else { return }
        self.elements = [
            0: TextFieldElement(text: user.firstName, placeholder: "Enter first name", error: "First name cannot be empty", index: 0, type: .plain, tag: "fname") ,
            1: TextFieldElement(text: user.lastName, placeholder: "Enter last name", error: "Last name cannot be empty", index: 1, type: .plain, tag: "lname") ,
            2: TextFieldElement(text: user.email, placeholder: "Enter Email", error: "Email cannot be empty", index: 2, type: .email, tag: "email"),
            3: TextFieldElement(text: user.about, placeholder: "Enter About", error: "About cannot be empty", index: 3, type: .plain, tag: "about"),
            4: DropDownElement(optionArray: self.getCountriesName(), error: "Enter valid country name", index:4, errorState: false, tag: "country", text: user.country),
            
            5: TextFieldElement(text: user.city, placeholder: "Enter City", error: "City cannot be empty", index: 5, type: .plain, tag: "city"),
            6: ButtonElement(title: "Save", index: 6),
        ]
        collectionView.reloadData()
    }
    
    @objc
    func onImageClick() {
        print("TEST")
        var imagePicker = UIImagePickerController()
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.modalPresentationStyle = .overFullScreen
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = profileImage
            alert.popoverPresentationController?.sourceRect = profileImage.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }
        present(alert, animated: true, completion: nil)
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
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let _ = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let fileURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? NSURL else { picker.dismiss(animated: true, completion: nil); return }
        profileURL = fileURL as URL
        do {
            try ApplicationDB.shared.setProfileMedia(mediaData: Data(contentsOf: fileURL as URL))
        }
        catch {
            print("Error: \(error)")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }

    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension ProfileEditViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch(elements[indexPath.row]) {
        case _ as TextFieldElement:
            return CGSize(width: collectionView.frame.width, height: 70)
        case _ as ButtonElement:
            return CGSize(width: collectionView.frame.width, height: 50)
        default:
            return CGSize(width: collectionView.frame.width, height: 70)
        }
    }
}

extension ProfileEditViewController: TextFormElementDelegate, SubmitButtonDelegate, SignInFormCellDelegate, FormPickerElementDelegate {
    
    func notifyChange(textFieldProp: TextFieldElement) {
        (elements[textFieldProp.getIndex()] as? TextFieldElement)?.setText(text: textFieldProp.getText())
    }
    
    func formPicker(_ picker: DropDownWithError, prop propChanged: DropDownElement) {
        (elements[propChanged.index] as? DropDownElement)?.text = propChanged.text
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
               let about = dict["about"],
               ApplicationDB.shared.editUser(firstName: fname, lastName: lname, email: email, ph: "", country: country, city: city, about: about) {
                Toast.shared.showToast(message: "Changes Saved", type: .success)
                if let vc = navigationController?.presentingViewController as? ProfileViewController {
                    vc.loadData()
                }
                self.onSignup()
            } else {
                Toast.shared.showToast(message: "Unable to save changes")
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


