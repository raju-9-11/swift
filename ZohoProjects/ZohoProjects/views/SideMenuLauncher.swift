//
//  File.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 28/11/21.
//

import UIKit

class SideMenuLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var containerView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let profilePic: ProfileImageView = {
        let imageView = ProfileImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.text = "Username Initial"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray6
        label.text = "test@email.com"
        return label
    }()
    
    let topMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let bellIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    let subContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let search: Search = {
        let bar = Search()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search"
        return bar
    }()
    
    let teamButton: DropDownButton  = {
        let button = DropDownButton()
        button.customImageView.image = UIImage(systemName: "chevron.right")
        button.setLabelName("Pacman")
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    
    
    let cellID = "myCell"
    
    let menuItems: [MenuItem] = {
        return [MenuItem(name: "Ungrouped Projects", icon: "barcode"), MenuItem(name: "Manage Projects", icon: "gear"), MenuItem(name: "Settings", icon: "gearshape.fill"), MenuItem(name: "Feedback", icon: "bubble.right.fill")]
    }()
    
    func showMenu() {
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            search.becomeFirstResponder()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            containerView.alpha = 0
            containerView.frame = keyWindow.frame
            keyWindow.addSubview(containerView)
            keyWindow.addSubview(subContainerView)
            topMenuView.addSubview(bellIcon)
            profileView.addSubview(profilePic)
            profileView.addSubview(topLabel)
            profileView.addSubview(subTitleLabel)
            topMenuView.addSubview(profileView)
            subContainerView.addSubview(topMenuView)
            subContainerView.addSubview(search)
            subContainerView.addSubview(collectionView)
            subContainerView.frame = CGRect(x: -keyWindow.frame.width, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
            self.setupLayout()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.containerView.alpha = 1
                self.subContainerView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
            }, completion: nil)
        }
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            bellIcon.topAnchor.constraint(equalTo: topMenuView.safeAreaLayoutGuide.topAnchor),
            bellIcon.rightAnchor.constraint(equalTo: topMenuView.rightAnchor, constant: -15),
            profileView.heightAnchor.constraint(equalTo: topMenuView.heightAnchor, multiplier: 0.3),
            profileView.widthAnchor.constraint(equalTo: topMenuView.widthAnchor),
            profileView.centerXAnchor.constraint(equalTo: topMenuView.centerXAnchor),
            profileView.topAnchor.constraint(equalTo: bellIcon.bottomAnchor, constant: 5),
            profilePic.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            profilePic.leftAnchor.constraint(equalTo: profileView.safeAreaLayoutGuide.leftAnchor, constant: 5),
            profilePic.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.9),
            profilePic.widthAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.9),
            topLabel.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            topLabel.bottomAnchor.constraint(equalTo: profileView.centerYAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: profileView.centerYAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            topMenuView.topAnchor.constraint(equalTo: subContainerView.topAnchor),
            topMenuView.widthAnchor.constraint(equalTo: subContainerView.widthAnchor),
            topMenuView.centerXAnchor.constraint(equalTo: subContainerView.centerXAnchor),
            topMenuView.heightAnchor.constraint(equalTo: subContainerView.heightAnchor, multiplier: 0.2),
            search.topAnchor.constraint(equalTo: topMenuView.bottomAnchor),
            search.widthAnchor.constraint(equalTo: subContainerView.widthAnchor),
            search.centerXAnchor.constraint(equalTo: subContainerView.centerXAnchor),
            search.heightAnchor.constraint(equalToConstant: 40),
            collectionView.topAnchor.constraint(equalTo: search.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: subContainerView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: subContainerView.widthAnchor),
            collectionView.centerXAnchor.constraint(equalTo: subContainerView.centerXAnchor),
        ])
    }

    
    
    @objc
    func dismissMenu() {
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene})
            .first?.windows
            .filter({ $0.isKeyWindow}).first {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.subContainerView.frame = CGRect(x: -keyWindow.frame.width, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
                self.containerView.alpha = 0
            }, completion: {
                _ in
                self.containerView.removeFromSuperview()
                self.subContainerView.removeFromSuperview()
                self.search.resignFirstResponder()
            })
            
        }
    }
    
    override init() {
        super.init()
        collectionView.register(SideMenuCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width - 1, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SideMenuCollectionViewCell
        cell.itemString = menuItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
}

class Search: UITextField {
    
    let padding = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
    
    let searchImage: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        view.addSubview(imageView)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.leftView = searchImage
        self.leftViewMode = .always
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return bounds.inset(by: padding)
    }
    

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class MenuItem: NSObject {
    var name: String
    var icon: String
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}

class ProfileImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateRad()
    }
    
    func updateRad() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

