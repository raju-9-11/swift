//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate, ModalViewDelegate, UITextFieldDelegate, UISearchBarDelegate {
    
    var auth: Auth? = nil
    let lvc = LoginViewController()
    
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
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, auth: Auth) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.auth = auth
        
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
        homeButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = homeButton
        self.navigationItem.titleView = searchBar
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
            if let auth = auth {
                if !auth.authState {
                    displayOn(viewController: viewController)
                    return true
                }
            } else {
                displayOn(viewController: viewController)
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
            searchBar.becomeFirstResponder()
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching: \(searchBar.text ?? "")")
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
        lvc.modalPresentationStyle = .fullScreen
        lvc.modalTransitionStyle = .coverVertical
        lvc.delegate = self
        viewController.addChild(lvc)
        self.navigationController?.isNavigationBarHidden = true
        viewController.view.addSubview(lvc.view)
    }
    
}
