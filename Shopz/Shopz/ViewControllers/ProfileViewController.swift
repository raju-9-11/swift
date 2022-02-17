//
//  ProfileViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ProfileViewController: CustomViewController {
    
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
        cv.register(ProfileReviewsViewCollectionViewCell.self, forCellWithReuseIdentifier: ProfileReviewsViewCollectionViewCell.cellID)
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
        present(imageView, animated: true, completion: nil)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.elements[0] = ProfileData(bgImageMediaURL: nil, profileImageMediaURL: nil)
        self.containerView.reloadData()
    }
    
    func loadData() {
        guard let user = Auth.auth?.user else { return }
        elements = [
            AboutData(),
            ShoppingListData(shoppingLists: ApplicationDB.shared.getShoppingLists()),
            ProfileFooterElement()
        ]
        if let profileImageURL = ApplicationDB.shared.getProfileMedia(userId: user.id) {
            elements.insert(ProfileData(
                bgImageMediaURL: profileImageURL,
                profileImageMediaURL: profileImageURL
            ), at: 0)
        } else {
            elements.insert(ProfileData(
                bgImageMediaURL: nil,
                profileImageMediaURL: nil
            ), at: 0)
        }
            
        
        let reviews = ApplicationDB.shared.getUserReviews()
        if !reviews.isEmpty {
            elements.insert(ProfileReviewListElemrnt(reviews: reviews), at: 3)
        }
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
        if let reviewsData = item as? ProfileReviewListElemrnt {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ProfileReviewsViewCollectionViewCell.cellID, for: indexPath) as! ProfileReviewsViewCollectionViewCell
            cell.cellFrame = collectionView.frame
            cell.delegate = self
            cell.reviewElementData = reviewsData
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

extension ProfileViewController: ShoppingListCellDelegate, ProfileImagesViewDelegate, ShoppingListViewDelegate, ProfileReviewsViewDelegate {
    
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
    
    func editTapped() {
        guard let user = Auth.auth?.user else { return }
        let profileEditVC = ProfileEditViewController()
        profileEditVC.profileURL = ApplicationDB.shared.getProfileMedia(userId: user.id)
        profileEditVC.modalTransitionStyle = .crossDissolve
        profileEditVC.modalPresentationStyle = .overFullScreen
        self.present(profileEditVC, animated: true, completion: nil)
    }
    
    func reviewSelect(review: Review, product: Product) {
        self.displayProduct(product: product)
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
    
    var bgImageMediaURL: URL?
    var profileImageMediaURL: URL?
    
    init(bgImageMediaURL: URL?, profileImageMediaURL: URL?) {
        self.bgImageMediaURL = bgImageMediaURL
        self.profileImageMediaURL = profileImageMediaURL
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

final class ProfileReviewListElemrnt: ProfileViewElement {
    var reviews: [Review]
    
    init(reviews: [Review]) {
        self.reviews = reviews
    }
}

final class ProfileFooterElement: ProfileViewElement {
    
}


