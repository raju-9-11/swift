//
//  MainViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 21/11/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.7
    
    var menuViewConstraint: NSLayoutConstraint!
    var closeMenuButton: UIButton!
    var searchBar: UITextField!
    
    var isSlidingMenuVisible: Bool = false {
        didSet {
            menuView.isHidden = oldValue
        }
    }
    
    var currTab: String = "Feed"
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuToggle))
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    var profileView: UIView!
    
    override func loadView() {
        super.loadView()
        self.delegate = self
        self.setupNavigationController()
        
        view.backgroundColor = .white
        
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        menuView.layer.shadowColor = UIColor.darkGray.cgColor
        menuView.layer.shadowRadius = 1
        menuView.layer.shadowOffset = CGSize(width: 2, height: 10)
        menuView.layer.shadowOpacity = 0.8
        
        closeMenuButton = UIButton(type: .close, primaryAction: UIAction(handler: {
            _ in
            self.menuToggle()
        }))
        closeMenuButton.translatesAutoresizingMaskIntoConstraints = false
        
        profileView = UIView()
        profileView.backgroundColor = .black
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar = UITextField()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.layer.borderColor = UIColor.systemGray2.cgColor
        searchBar.layer.borderWidth = 0.5
        searchBar.leftViewMode = .always
        searchBar.leftView = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        searchBar.rightViewMode = .unlessEditing
        searchBar.rightView = UIImageView(image: UIImage(systemName: "square.and.arrow.down"))
        menuView.addSubview(searchBar)
        menuView.addSubview(profileView)
        menuView.addSubview(closeMenuButton)
        menuView.isHidden = true
        
        
        self.setUpLayout()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currTab = item.title ?? "Home"
        self.navigationItem.title = currTab
        
    }
    
    func setupNavigationController() {
        self.navigationItem.title = currTab
        self.navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowRadius = 1
        self.tabBar.layer.shadowOpacity = 0.2
    }
    
    @objc
    func menuToggle() {
        self.isSlidingMenuVisible.toggle()

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.menuViewConstraint.constant = self.isSlidingMenuVisible ? self.slideInMenuPadding : -10
            self.navigationController?.navigationBar.isHidden.toggle()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setUpLayout() {
        menuViewConstraint = menuView.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -10)
        menuViewConstraint.isActive = true
        NSLayoutConstraint.activate([
            closeMenuButton.topAnchor.constraint(equalTo: menuView.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileView.topAnchor.constraint(equalTo: menuView.topAnchor),
            profileView.leftAnchor.constraint(equalTo: menuView.leftAnchor),
            profileView.rightAnchor.constraint(equalTo: menuView.rightAnchor),
            profileView.heightAnchor.constraint(equalTo: menuView.heightAnchor, multiplier: 0.23),
            searchBar.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            searchBar.heightAnchor.constraint(equalTo: menuView.heightAnchor, multiplier: 0.06),
            searchBar.leftAnchor.constraint(equalTo: menuView.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: menuView.rightAnchor),
        ])
        
    }
    
}

public extension UIView {
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ])
    }
}
