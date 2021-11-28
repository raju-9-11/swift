//
//  MainViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 21/11/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    let settingsLauncher = SettingsLauncher()
    
    var button: UIBarButtonItem!
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuClicked))
    
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
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        button.title = item.title ?? "Home"
        
    }
    
    func setupNavigationController() {
        button = UIBarButtonItem(title: "Feed", image: nil, primaryAction: nil, menu: .none)
        button.isEnabled = false
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 15, weight: .heavy)], for: .disabled)
        self.navigationItem.leftBarButtonItems = [menuBarButtonItem, button]
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowRadius = 1
        self.tabBar.layer.shadowOpacity = 0.2
    }
    
    @objc
    func menuClicked() {
        settingsLauncher.showSettings()
    }
}
