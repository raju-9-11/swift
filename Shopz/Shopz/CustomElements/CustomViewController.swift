//
//  CustomViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 30/01/22.
//

import UIKit

class CustomViewController: UIViewController {
    
    var requiresAuth: Bool = false
    
    var pvc: ProductViewController?
    
    var searchVC: SearchViewController?
    
    var searchBarIsVisible: Bool = false {
        willSet {
            self.searchBar.text = ""
            UIView.animate(withDuration: 0.2,animations: {
                self.navigationItem.titleView = nil
                if newValue {
                    self.navigationItem.titleView = self.searchBar
                    self.searchBar.becomeFirstResponder()
                } else {
                    self.searchButton.image = UIImage(systemName: "magnifyingglass.circle")
                    self.searchButton.title = ""
                    self.searchBar.resignFirstResponder()
                    self.searchBarList.removeFromSuperview()
                    self.maskView.removeFromSuperview()
                }
                if self.searchBarAlwaysVisible {
                    self.navigationItem.titleView = self.searchBar
                }
            }, completion: {
                _ in
                self.navigationController?.navigationBar.layoutSubviews()
            })
            
            
        }
    }
    
    var searchBarAlwaysVisible: Bool =  false {
        willSet {
            self.searchBarIsVisible = newValue
        }
    }
    
    var searchListDataFiltered: [Product] = [] {
        didSet {
            searchBarListHeight?.isActive = false
            searchBarListHeight = searchBarList.heightAnchor.constraint(equalToConstant: min(CGFloat(searchListDataFiltered.count*50), self.view.frame.height*0.6))
            searchBarListHeight?.isActive = true
        }
    }
    
    var searchBarListHeight: NSLayoutConstraint?
    
    var lvc: LoginViewController?
    
    let maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.shopzBackGroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBarList: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.shopzBackGroundColor
        tv.register(SearchbarTableViewCell.self, forCellReuseIdentifier: SearchbarTableViewCell.cellID)
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "magnifyingglass.circle")
        return button
    }()
    
    let leftButton: UIBarButtonItem = {
        let leftButton = UIBarButtonItem()
        leftButton.image = UIImage(systemName: "chevron.left")
        leftButton.title = ""
        return leftButton
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search Shopz"
        return searchBar
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self == self.navigationController?.rootViewController {
            self.leftButton.image = nil
        } else {
            self.leftButton.image = UIImage(systemName: "chevron.left")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBarIsVisible = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.shopzBackGroundColor
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        leftButton.target = self
        leftButton.action = #selector(onBack)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        if self.navigationController?.rootViewController != self {

            if #available(iOS 14, *) {
                var actions = self.navigationController?.viewControllers.map({
                    vc in
                    return UIAction(title: vc.title ?? "Back", handler: {
                        _ in
                        self.navigationController?.popToViewController(vc, animated: true)
                    })
                })
                actions?.removeLast()
                leftButton.menu = UIMenu(children: actions ?? [] )
            }
            
        }

        searchButton.target = self
        searchButton.action = #selector(onSearchButtonClick)
        
        
        searchBar.delegate = self
        searchBarList.delegate = self
        searchBarList.dataSource = self
        
        if Auth.auth == nil && requiresAuth {
            self.displayLogin()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
    }

    
    deinit {
        pvc = nil
        searchVC = nil
        lvc = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func onBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func onSearchButtonClick() {
        searchBarIsVisible.toggle()
    }
    
    
    @objc
    func onLogin() {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.lvc = nil
    }
    
    func displayLogin() {
        if self.requiresAuth {
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            lvc = nil
            lvc = LoginViewController()
            self.navigationController?.pushViewController(lvc!, animated: true)
        }
    }
    
    @objc
    func onLogout() {
        self.displayLogin()
    }
    
    func displayProduct(product: Product) {
        pvc = nil
        pvc = ProductViewController()
        pvc!.productData = product
        self.navigationController?.pushViewController(pvc!, animated: true)
    }
    
    func displayProducts(with products: [Product]) {
        searchVC = nil
        searchVC = SearchViewController(products: products)
        self.navigationController?.pushViewController(searchVC!, animated: true)
    }
    
    func displayProducts(with categories: [Category]) {
        searchVC = nil
        searchVC = SearchViewController(categories: categories)
        self.navigationController?.pushViewController(searchVC!, animated: true)
    }
    
    func setupLayout() {
        // Code here
    }

    func removeViews() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension CustomViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchListDataFiltered = []
        } else {
            self.searchListDataFiltered = StorageDB.getProducts().filter({ prod in return prod.product_name.lowercased().fuzzyMatch(searchText.lowercased()) })
        }
        
        searchBarList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        displayProducts(with: self.searchListDataFiltered)
        searchBarIsVisible = false
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchButton.image = nil
        self.searchButton.title = "Cancel"
        
        self.view.addSubview(maskView)
        self.view.addSubview(searchBarList)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar)))
        
        NSLayoutConstraint.activate([
            maskView.heightAnchor.constraint(equalTo: view.heightAnchor),
            maskView.widthAnchor.constraint(equalTo: view.widthAnchor),
            maskView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            maskView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBarList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBarList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarList.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        searchBarListHeight?.isActive = false
        searchBarListHeight = searchBarList.heightAnchor.constraint(equalToConstant: 0)
        searchBarListHeight?.isActive = true
        
        
        self.searchListDataFiltered = []
        searchBarList.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !searchBarAlwaysVisible {
            self.searchBar.text = ""
            self.searchBarIsVisible = false
        }
    }
    
    @objc
    func dismissSearchBar() {
        self.searchBarIsVisible = false
    }
}

extension CustomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListDataFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchbarTableViewCell.cellID) as! SearchbarTableViewCell
        cell.text = searchListDataFiltered[indexPath.row].product_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pvc == nil {
            pvc = ProductViewController()
        }
        pvc?.productData = searchListDataFiltered[indexPath.row]
        self.navigationController?.pushViewController(pvc!, animated: true)
        searchBarIsVisible = false
    }
}

extension CustomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}
