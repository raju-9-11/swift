//
//  AppDelegate.swift
//  Shopz
//
//  Created by Rajkumar S on 07/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let newAuthSate = Auth()
        newAuthSate.authState = false
        let vc = MainController()
        vc.auth = newAuthSate
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        let cartVC = CartViewController()
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        vc.viewControllers = [homeVC, profileVC, cartVC]
        vc.selectedViewController = homeVC
        self.window?.rootViewController = UINavigationController(rootViewController: vc)
        return true
    }


}

