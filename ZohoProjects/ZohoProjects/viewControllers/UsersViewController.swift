//
//  UsersViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let users: [UserDataModel] = {
        return [UserDataModel(name: "Pacman", email: "pacman@ghost.com", role: .admin, profile: .admin, image: UIImage(systemName: "person.crop.artframe")), UserDataModel(name: "John", email: "john@ghost.com", role: .member, profile: .vadmin, image: UIImage(systemName: "person.crop.square")), UserDataModel(name: "Jane", email: "jane@ghost.com", role: .member, profile: .vendor, image: UIImage(systemName: "person.badge.clock"))]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UsersCollectionViewCell
        cell.userData = users[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 10, height: 100)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    

}


class UserDataModel {
    var name: String
    var email: String
    var role: UserRole?
    var profile: UserProfile?
    var image: UIImage?
    
    init(name: String, email: String, role: UserRole? = nil ,profile: UserProfile? = nil, image: UIImage?) {
        self.name = name
        self.email = email
        self.profile = profile
        self.role = role
        self.image = image
    }
}


enum UserRole: String {
    case admin = "Admin", manager = "Manager", member = "Member", client = "Client", vendor = "Vendor"
}

enum UserProfile: String {
    case admin = "Admin", vadmin = "View-Only Admin", manager = "Manager", member = "Member", client = "Client", vendor = "Vendor"
}

