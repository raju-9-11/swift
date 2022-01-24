//
//  ProfileViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ProfileViewController: CustomViewController, UICollectionViewDataSource, UICollectionViewDelegate, ShoppingListCellDelegate, ImagesViewDelegate, ShoppingListViewDelegate {
    
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
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        svc = nil
    }
    
    func displayImage(_ image: UIImage?) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        newImageView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func listItemClicked(indexPath: IndexPath, shoppingListData: ShoppingList?) {
        if svc == nil {
            svc = CartViewController()
            svc?.delegate = self
        }
        if let listData = shoppingListData {
            svc!.listDetails = listData
            svc!.willMove(toParent: self)
            self.addChild(svc!)
            self.view.addSubview(svc!.view)
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
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
        
    }
    
    func deleteListClicked(list: ShoppingList) {
        ApplicationDB.shared.removeShoppingList(list: list)
        self.loadData()
    }
    
    override func setupLayout() {

        view.backgroundColor = .systemGray

        containerView.delegate = self
        containerView.dataSource = self
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
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
            ShoppingListData(shoppingLists: ApplicationDB.shared.getShoppingLists())
        ]
        containerView.reloadData()
    }
    
    @objc
    func onLogin() {
        self.setupLayout()
    }
    
    @objc
    func onLogout() {
        self.removeViews()
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

class ShoppingList {
    var name: String
    var id: Int
    var userId: Int
    
    init(id: Int, name: String, userID: Int) {
        self.name = name
        self.id = id
        self.userId = userID
    }
}

extension UIImage {
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
}
