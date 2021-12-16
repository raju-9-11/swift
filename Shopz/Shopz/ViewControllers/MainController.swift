//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate, ModalViewDelegate {
    
    var auth: Auth? = nil
    
    let searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search Items"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Main"
        view.backgroundColor = .systemGray
        self.delegate = self
        
        self.tabBar.backgroundColor = .white
        self.setupNavigationController()
        
    }
    
    func sendState(vc: UIViewController, _ state: Auth) {
        self.auth = state
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag > 0 {
            if let auth = auth, !auth.authState {
                let lvc = LoginViewController()
                lvc.modalPresentationStyle = .fullScreen
                lvc.modalTransitionStyle = .coverVertical
                lvc.delegate = self
                self.present(lvc, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    func setupNavigationController() {
        searchBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController?.navigationBar.frame.height ?? 200)
        searchBarView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: searchBarView.centerXAnchor),
            searchBar.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchBar.heightAnchor.constraint(equalTo: searchBarView.heightAnchor, multiplier: 0.99),
        ])
        self.navigationItem.titleView = searchBarView
    }
    
    override func viewWillLayoutSubviews() {
        searchBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController?.navigationBar.frame.height ?? 200)
    }
    

}
