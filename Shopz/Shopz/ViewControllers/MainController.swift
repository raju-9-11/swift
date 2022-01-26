//
//  MainController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class MainController: UITabBarController, UITextFieldDelegate, UISearchBarDelegate {
    
    var lvc: LoginViewController?
    
    var custTabbar: UITabBar?
    
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
        view.backgroundColor = UIColor(named: "background_color")!.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchList: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "background_coloras")
        tv.register(SearchbarTableViewCell.self, forCellReuseIdentifier: SearchbarTableViewCell.cellID)
        return tv
    }()
    
    let pvc = ProductViewController()
    
    
    var searchListDataFiltered: [ Product ] = []
    
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

        view.backgroundColor = UIColor(named: "background_color")
        self.delegate = self
        self.tabBar.backgroundColor = UIColor(named: "tabbar_color")?.withAlphaComponent(0.5)
        self.tabBar.tintColor = UIColor(named: "tabbar_text_color")
        self.tabBar.unselectedItemTintColor = UIColor(named: "tabbar_unselected_color")
        
        searchBar.delegate = self
        searchList.delegate = self
        searchList.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
        self.navigationItem.titleView = searchBar
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
            DispatchQueue.main.async {
                self.displayOn(viewController: vc)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchListDataFiltered = []
        } else {
            self.searchListDataFiltered = StorageDB.getProducts().filter({ prod in return prod.product_name.fuzzyMatch(searchText) })
        }
        searchList.frame.size.height = CGFloat(self.searchListDataFiltered.count*50)
        searchList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        displayProducts(with: self.searchListDataFiltered)
        self.onDismiss()
    }
    
    func displayProducts(with category: Category) {
        self.selectedIndex = 3
        if let vc = self.selectedViewController as? SearchViewController {
            vc.loadData(with: [category])
        }
    }
    
    func displayProducts(with products: [Product]) {
        self.selectedIndex = 3
        if let vc = self.selectedViewController as? SearchViewController {
            vc.loadData(with: products)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchList.frame = self.view.frame
        searchList.frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.height
        searchList.frame.size.height = 0
        self.view.addSubview(containerView)
        self.view.addSubview(searchList)
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
        searchList.removeFromSuperview()
        containerView.removeFromSuperview()
    }
    
    @objc
    func loadHome() {
        self.selectedIndex = 0
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

extension MainController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListDataFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchbarTableViewCell.cellID) as! SearchbarTableViewCell
        cell.textLabel?.text = searchListDataFiltered[indexPath.row].product_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pvc.productData = searchListDataFiltered[indexPath.row]
        pvc.willMove(toParent: selectedViewController)
        selectedViewController?.addChild(pvc)
        selectedViewController?.view.addSubview(pvc.view)
        self.onDismiss()
    }
}

extension MainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? CustomViewController {
            vc.children.forEach({ $0.view.removeFromSuperview(); $0.removeFromParent() })
        }
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
