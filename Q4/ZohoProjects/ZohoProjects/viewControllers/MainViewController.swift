//
//  MainViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 21/11/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    let settingsLauncher = SettingsLauncher()
    
    var button: CustomFeedTitle!
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "menucard.fill")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuClicked))
    
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
        button.setMainTitle(name: item.title ?? "Home")
        button.setProjectTitle(name: "Test")
    }
    
    func setupNavigationController() {
        button = CustomFeedTitle()
        button.setMainTitle(name: "Feed")
        button.setProjectTitle(name: "Test")
        button.isEnabled = false
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 15, weight: .heavy)], for: .disabled)
        self.navigationItem.leftBarButtonItems = [menuBarButtonItem, button]
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowColor = UIColor.systemGray3.cgColor
        self.tabBar.layer.shadowRadius = 1
        self.tabBar.layer.shadowOpacity = 0.2
    }
    
    @objc
    func menuClicked() {
        settingsLauncher.showMenu()
    }
}

public extension UIApplication {

    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene})
                .first?.windows
                .filter({ $0.isKeyWindow }).first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
