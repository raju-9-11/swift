//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITextFieldDelegate, UISearchBarDelegate {
    
    var custTabbar: UITabBar?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setTabs()
    }
    
    func setTabs() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        let cartVC = UINavigationController(rootViewController: CartViewController())
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        let orderhistVC = UINavigationController(rootViewController: OrderHistoryViewController())
        orderhistVC.tabBarItem = UITabBarItem(title: "Order history", image: UIImage(systemName: "photo.fill"), tag: 4)
        let searchV = UINavigationController(rootViewController: SearchViewController())
        searchV.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        let orderhistV = UINavigationController(rootViewController: OrderHistoryViewController())
        orderhistV.tabBarItem = UITabBarItem(title: "Order history", image: UIImage(systemName: "photo.fill"), tag: 4)
        self.viewControllers = [homeVC, profileVC, cartVC, searchVC, orderhistVC, searchV, orderhistV]
        self.selectedViewController = homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.shopzBackGroundColor
        self.delegate = self
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = UIColor.shopzBackGroundColor.withAlphaComponent(0.5)
        self.tabBar.tintColor = UIColor.appTextColor
        self.tabBar.unselectedItemTintColor = UIColor.tabbarUnselectedColor
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func loadHome() {
        self.selectedIndex = 0
    }
    
}

extension MainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? CustomViewController {
            // Code here
        }
        
        if let vc = selectedViewController as? SearchViewController {
            vc.searchBar.becomeFirstResponder()
        }
        return true
    }
    

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.25

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
//        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        fromFrameEnd.origin.y = fromFrameEnd.origin.y + fromFrameEnd.height
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }

    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}

class CustomTabbarItem: UIView {
    
}
