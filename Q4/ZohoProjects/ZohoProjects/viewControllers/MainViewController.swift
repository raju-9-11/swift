//
//  MainViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 21/11/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onSideMenuClick))
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.delegate = self

        view.backgroundColor = .white
        self.setupNavigationController()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationItem.title = item.title ?? "Home"
    }
    
    
    
    func setupNavigationController() {
        self.navigationItem.title = "Feed"
        self.navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        self.tabBar.backgroundColor = .white
    }
    
    @objc
    func onSideMenuClick() {
        print("Side menu clicked!")
    }
    
}

public extension UIView {
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func pinMenuTo(_ view: UIView, constant: CGFloat) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.topAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}
