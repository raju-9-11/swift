//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate, UITextFieldDelegate, UISearchBarDelegate {
    
    var lvc: LoginViewController?
    
    override open var selectedIndex: Int {
        willSet {
            self.onDismiss()
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setTabs()
    }
    
    func setTabs() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        let cartVC = CartViewController()
        cartVC.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        let orderhistVC = OrderHistoryViewController()
        orderhistVC.tabBarItem = UITabBarItem(title: "Order history", image: UIImage(systemName: "photo.fill"), tag: 4)
        self.viewControllers = [homeVC, profileVC, cartVC, searchVC, orderhistVC]
        self.selectedViewController = homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        self.delegate = self
        
        searchBar.delegate = self
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(loadHome))
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
        homeButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = homeButton
        self.navigationItem.titleView = searchBar
        self.tabBar.backgroundColor = .white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.lvc = nil
    }
    
    @objc
    func onLogin() {
        lvc?.willMove(toParent: nil)
        lvc?.view.removeFromSuperview()
        lvc?.removeFromParent()
        self.navigationController?.isNavigationBarHidden = false
        self.lvc = nil
    }
    
    @objc
    func onLogout() {
        if let vc = selectedViewController as? CustomViewController, vc.requiresAuth {
            print("TEST")
            DispatchQueue.main.async {
                self.displayOn(viewController: vc)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? CustomViewController, vc.requiresAuth {
            if Auth.auth == nil {
                displayOn(viewController: viewController)
                return true
            }
        } else {
            self.navigationController?.isNavigationBarHidden = false
        }
        
        if viewController.tabBarItem.tag == 3 {
            searchBar.becomeFirstResponder()
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching: \(searchBar.text ?? "")")
        self.onDismiss()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.view.addSubview(containerView)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
    
    @objc
    func onDismiss() {
        searchBar.resignFirstResponder()
        containerView.removeFromSuperview()
    }
    
    @objc
    func loadHome() {
        self.selectedIndex = 0
    }
    
    func onSearch(query: String?) {
        print("Searching for \(query ?? "")...")
    }

    
    func displayOn(viewController: UIViewController) {
        if  lvc == nil {
            lvc = LoginViewController()
        }
        lvc!.modalPresentationStyle = .fullScreen
        lvc!.modalTransitionStyle = .coverVertical
        viewController.addChild(lvc!)
        self.navigationController?.isNavigationBarHidden = true
        viewController.view.addSubview(lvc!.view)
    }
    
}
