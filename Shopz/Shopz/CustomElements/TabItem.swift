//
//  TabItem.swift
//  Shopz
//
//  Created by Rajkumar S on 26/01/22.
//
// MARK: To be Implemented

import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case cart = "cart"
    case search = "search"
    case profile = "profile"
    case history = "history"
    
    var viewController: CustomViewController {
        
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
        
        switch self {
        case .home:
            return homeVC
        case .cart:
            return cartVC
        case .search:
            return searchVC
        case .profile:
            return profileVC
        case .history:
            return orderhistVC
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
