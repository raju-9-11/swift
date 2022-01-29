//
//  ProfileViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ProfileViewController: CustomViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let containerView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.register(ProfileTopViewCollectioViewCell.self, forCellWithReuseIdentifier: ProfileTopViewCollectioViewCell.cellID)
        cv.register(AboutCollectionViewCell.self, forCellWithReuseIdentifier: AboutCollectionViewCell.cellID)
        cv.register(ShoppingListCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingListCollectionViewCell.cellID)
        cv.register(ProfileFooterViewCollectionViewCell.self, forCellWithReuseIdentifier: ProfileFooterViewCollectionViewCell.cellID)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    var imagePicker = UIImagePickerController()
    
    var svc: CartViewController? = nil
    
    var elements: [ProfileViewElement] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    } 
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.requiresAuth = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
        }
    }
    
    deinit {
        svc = nil
    }
    
    func displayImage(_ image: UIImage?) {
        let imageView = ImageSlideShow()
        imageView.image = image
        imageView.delegate = self
        self.view.addSubview(imageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func pickProfilePic(_ sender: UIImageView) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.imagePicker = UIImagePickerController()
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                self.imagePicker.modalPresentationStyle = .overFullScreen
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .overFullScreen
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
            
        self.present(alert, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else { return }
        elements[0] = ProfileData(bgImageMedia: image.jpegData(compressionQuality: 1), profileImageMedia: image.jpegData(compressionQuality: 1))
        containerView.reloadData()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }

    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

    
    override func setupLayout() {

        self.title = "Profile"
        view.backgroundColor = UIColor(named: "profile_background")

        containerView.delegate = self
        containerView.dataSource = self
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        elements = [
            ProfileData(bgImageMedia: UIImage(systemName: "photo.fill")?.pngData(), profileImageMedia: UIImage(systemName: "person.circle.fill")?.pngData()),
            AboutData(),
            ShoppingListData(shoppingLists: ApplicationDB.shared.getShoppingLists()),
            ProfileFooterElement()
        ]
        containerView.reloadData()
    }
    
    @objc
    override func onLogin() {
        super.onLogin()
        self.loadData()
        self.setupLayout()
    }
    
    @objc
    override func onLogout() {
        super.onLogout()
    }

}


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = elements[indexPath.row]
        if let profileItem = item as? ProfileData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ProfileTopViewCollectioViewCell.cellID, for: indexPath) as! ProfileTopViewCollectioViewCell
            cell.cellFrame = collectionView.frame
            cell.delegate = self
            cell.profileData = profileItem
            return cell
        }
        if let aboutData = item as? AboutData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: AboutCollectionViewCell.cellID, for: indexPath) as! AboutCollectionViewCell
            cell.aboutData = aboutData
            cell.cellFrame = collectionView.frame
            return cell
        }
        if let shoppingListData = item as? ShoppingListData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.cellID, for: indexPath) as! ShoppingListCollectionViewCell
            cell.shoppingListData = shoppingListData
            cell.cellFrame = collectionView.frame
            cell.delegate = self
            return cell
        }
        if let _ = item as? ProfileFooterElement {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ProfileFooterViewCollectionViewCell.cellID, for: indexPath) as! ProfileFooterViewCollectionViewCell
            cell.cellFrame = collectionView.frame
            return cell
        }
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
        
    }
}

extension ProfileViewController: ShoppingListCellDelegate, ProfileImagesViewDelegate, ShoppingListViewDelegate {
    
    func listItemClicked(indexPath: IndexPath, shoppingListData: ShoppingList?) {
        if svc == nil {
            svc = CartViewController()
            svc?.delegate = self
        }
        if let listData = shoppingListData {
            svc?.listDetails = listData
            svc?.title = "\(listData.name)"
            self.navigationController?.pushViewController(svc!, animated: true)
        }
    }
    
    func addClicked() {
        let alert = UIAlertController(title: "Create Shopping List", message: "Enter name for Shopping List: ", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Enter name"
        })
        let action = UIAlertAction(title: "Create", style: .default, handler: {
            _ in
            let textField = alert.textFields![0]
            if let text = textField.text, text.isEmpty {
                Toast.shared.showToast(message: "Name cannot be empty!!")
                return
            }
            ApplicationDB.shared.addShoppingList(name: textField.text ?? "Untitled")
            self.loadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func rename(list: ShoppingList?) {
        guard let list = list else {
            return
        }
        let alert = UIAlertController(title: "Rename Shopping List", message: "Enter new name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Shopping List name"
        })
        let renameAction = UIAlertAction(title: "Rename", style: .default, handler: {
            _ in
            let textField = alert.textFields![0]
            if let text = textField.text, text.isEmpty {
                Toast.shared.showToast(message: "Name cannot be empty!!")
                return
            }
            ApplicationDB.shared.renameShoppingList(list: list, name: textField.text ?? "")
            self.loadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(renameAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func delete(list: ShoppingList?) {
        guard let list = list else {
            return
        }
        ApplicationDB.shared.removeShoppingList(list: list)
        self.loadData()
    }
    
    func deleteListClicked(list: ShoppingList) {
        ApplicationDB.shared.removeShoppingList(list: list)
        self.loadData()
    }
}

extension ProfileViewController: ImageSlideShowDelegate {
    func onHide(_ imageSlideShow: ImageSlideShow) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}

class RoundedImage: UIImageView {
    var isRounded: Bool = true
    
    override func layoutSubviews() {
        if isRounded {
            super.layoutSubviews()
            self.layer.cornerRadius = min(self.bounds.height, self.bounds.width) / 2
        }
    }
    
}

class ProfileViewElement {
    var id = UUID()
}


final class ProfileData: ProfileViewElement {
    
    var bgImageMedia: Data?
    var profileImageMedia: Data?
    
    init(bgImageMedia: Data?, profileImageMedia: Data?) {
        self.bgImageMedia = bgImageMedia
        self.profileImageMedia = profileImageMedia
    }
}

final class AboutData: ProfileViewElement {
    
}

final class ShoppingListData: ProfileViewElement {
    var shoppingLists: [ShoppingList] = []
    
    init(shoppingLists: [ShoppingList]) {
        self.shoppingLists = shoppingLists
    }
}

final class ProfileFooterElement: ProfileViewElement {
    
}


