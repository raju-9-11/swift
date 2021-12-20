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
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        vc.viewControllers = [homeVC, profileVC, cartVC, searchVC]
        vc.selectedViewController = homeVC
        let cvc = CustomNavigationController(rootViewController: vc)
        cvc.customDelegate = vc
        self.window?.rootViewController = cvc
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("Excessive memory warning")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Before background")
        window?.isHidden = true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Before foreground")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Going back ground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("After Foreground")
        window?.isHidden = false 
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("About to terminate")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }


}

