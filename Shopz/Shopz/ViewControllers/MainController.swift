//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate, ModalViewDelegate, UITextFieldDelegate, CustomNavigationDelegate {
    
    var auth: Auth? = nil
    let lvc = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Main"
        view.backgroundColor = .systemGray
        self.delegate = self
        
        self.tabBar.backgroundColor = .white
    }
    
    func sendState(vc: UIViewController, _ state: Auth) {
        self.auth = state
        if let auth = auth, auth.authState == true {
            lvc.willMove(toParent: nil)
            lvc.view.removeFromSuperview()
            lvc.removeFromParent()
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? CustomViewController, vc.requiresAuth {
            if let auth = auth, !auth.authState {
                lvc.modalPresentationStyle = .fullScreen
                lvc.modalTransitionStyle = .coverVertical
                lvc.delegate = self
                viewController.addChild(lvc)
                self.navigationController?.isNavigationBarHidden = true
                viewController.view.addSubview(lvc.view)
                lvc.displayFullScreen(on: viewController.view)
                return true
            }
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
        if let viewController = viewController as? CustomViewController {
            viewController.removeViews()
            viewController.setupLayout()
        }
        
        if viewController.tabBarItem.tag == 3 {
            (self.navigationController as? CustomNavigationController)?.searchBar.becomeFirstResponder()
        }
        return true
    }
    
    func loadHome() {
        print("Loading home...")
    }
    
    
    func goToSearch() {
        print("Going...")
    }
    
    func onSearch(query: String?) {
        print("Searching for \(query ?? "")...")
    }
    
    func onLeft() {
        self.dismiss(animated: true, completion: nil)
        self.selectedIndex = 0
    }
    
}
