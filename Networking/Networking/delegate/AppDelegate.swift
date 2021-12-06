//
//  AppDelegate.swift
//  Networking
//
//  Created by Rajkumar S on 02/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }


}

