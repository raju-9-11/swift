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
        
        ApplicationDB.shared.getCurrentUser()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let vc = MainController()
        self.window?.rootViewController = vc
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return false
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

