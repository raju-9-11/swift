//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate, ModalViewDelegate {
    
    var auth: Auth? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Main"
        view.backgroundColor = .systemGray
        self.delegate = self
        
        
        
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
    

}
