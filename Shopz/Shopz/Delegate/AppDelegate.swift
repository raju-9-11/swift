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

        let newAuthSate: Auth? = nil
        
        let vc = MainController(auth: newAuthSate)

        let cvc = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = cvc
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("Excessive memory warning")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        ApplicationDB.shared.closeDB()
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
        _ = ApplicationDB.shared.initDB()
        print("After Foreground")
        window?.isHidden = false 
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ApplicationDB.shared.closeDB()
        print("About to terminate")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }


}

