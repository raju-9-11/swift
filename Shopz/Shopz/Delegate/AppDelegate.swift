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
    
    var userLoggedIn: Bool {
        get {
            return Auth.auth != nil
        }
    }
    
    var rootViewController: MainController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.getRootViewController()
        self.createWindowAndSetAsKey()
        self.window?.rootViewController = rootViewController
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
    
    func createWindowAndSetAsKey(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.isOpaque = true
        window?.alpha = 1.0
        window?.makeKeyAndVisible()
    }
    
    func getRootViewController() {
        self.rootViewController = MainController()
        ApplicationDB.shared.getCurrentUser()
    }


}
