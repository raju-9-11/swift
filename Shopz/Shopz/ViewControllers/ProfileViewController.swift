//
//  ProfileViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    let containerView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 50
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.register(ProfileTopViewCollectioViewCell.self, forCellWithReuseIdentifier: ProfileTopViewCollectioViewCell.cellID)
        cv.register(AboutCollectionViewCell.self, forCellWithReuseIdentifier: AboutCollectionViewCell.cellID)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    var containerData: [ProfileViewElement] = [
        ProfileData(name: "Pacman", bgImageMedia: "https://docs.swift.org/swift-book/_images/memory_shopping_2x.png", profileImageMedia: "https://www.gravatar.com/avatar/acee100932e6b180a64cf7a58ccab6d6.jpg?d=https%3A%2F%2Fwolverine.raywenderlich.com%2Fv3-resources%2Fimages%2Fdefault-account-avatar_2x.png&s=480", email: "test@email.com"),
        AboutData(about: ""),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        containerView.delegate = self
        containerView.dataSource = self
        
        
        view.addSubview(containerView)
        
        self.setupLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = containerData[indexPath.row]
        if let profileItem = item as? ProfileData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ProfileTopViewCollectioViewCell.cellID, for: indexPath) as! ProfileTopViewCollectioViewCell
            cell.cellFrame = self.view.frame
            cell.profileData = profileItem
            return cell
        }
        if let aboutData = item as? AboutData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: AboutCollectionViewCell.cellID, for: indexPath) as! AboutCollectionViewCell
            cell.aboutData = aboutData
            cell.cellFrame = self.view.frame
            return cell
        }
        if let shoppingListData = item as? ShoppingListData {
            let cell = containerView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.cellID, for: indexPath) as! ShoppingListCollectionViewCell
            cell.shoppingListData = shoppingListData
            cell.cellFrame = self.view.frame
            return cell
        }
        let cell = containerView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
        
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
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
    var name: String
    var bgImageMedia: String
    var profileImageMedia: String
    var email: String
    
    init(name: String, bgImageMedia: String, profileImageMedia: String, email: String) {
        self.name = name
        self.bgImageMedia = bgImageMedia
        self.profileImageMedia = profileImageMedia
        self.email = email
    }
}

final class AboutData: ProfileViewElement {
    var about: String
    
    init(about: String) {
        self.about = about
    }
}

final class ShoppingListData: ProfileViewElement {
    var shoppingLists: [ShoppingList] = []
    
    init(shoppingLists: [ShoppingList]) {
        self.shoppingLists = shoppingLists
    }
}

class ShoppingList {
    var name: String
    var id = UUID()
    
    init(name: String) {
        self.name = name
    }
}