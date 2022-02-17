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
            UIView.animate(withDuration: 0.2,animations: {
                self.navigationItem.titleView = nil
                if newValue {
                    self.navigationItem.titleView = self.searchBar
                    self.searchButton.image = nil
                    self.searchButton.title = "Cancel"
                    self.searchBarIsEditing = true
                } else {
                    self.searchButton.image = UIImage(systemName: "magnifyingglass.circle")
                    self.searchButton.title = ""
                    self.searchBarIsEditing = false
                }
            })
            
            DispatchQueue.main.async {
                if self.searchBarAlwaysVisible {
                    self.navigationItem.titleView = self.searchBar
                }
            }
            
        }
    }
    
    var searchBarAlwaysVisible: Bool =  false {
        willSet {
            if newValue {
                self.searchBarIsVisible = true
            }
        }
    }
    
    var searchBarIsEditing: Bool = false {
        willSet {
            if newValue {
                searchBar.becomeFirstResponder()
                self.view.addSubview(maskView)
                self.view.addSubview(searchBarList)
                maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar)))
                
                NSLayoutConstraint.activate([
                    maskView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
                    maskView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                    maskView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    maskView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    searchBarList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    searchBarList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                    searchBarList.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                ])
                searchBarListHeight = searchBarList.heightAnchor.constraint(equalToConstant: 0)
                searchBarListHeight?.isActive = true
            } else {
                searchBar.resignFirstResponder()
                searchBarList.removeFromSuperview()
                maskView.removeFromSuperview()
            }
        }
    }
    
    var searchListDataFiltered: [Product] = [] {
        willSet {
            searchBarListHeight?.constant = min(CGFloat(newValue.count*50), self.view.frame.height*0.6)
        }
    }
    
    var searchBarListHeight: NSLayoutConstraint?
    
    var lvc: LoginViewController?
    
    let maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBarList: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "background_color")
        tv.register(SearchbarTableViewCell.self, forCellReuseIdentifier: SearchbarTableViewCell.cellID)
        tv.isScrollEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "magnifyingglass.circle")
        button.tintColor = .systemBlue
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search Shopz"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background_color")
        
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationController?.navigationBar.isTranslucent = false
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
    func onSearchButtonClick() {
        searchBarIsVisible.toggle()
    }
    
    
    @objc
    func onLogin() {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
        self.lvc = nil
    }
    
    func displayLogin() {
        if self.requiresAuth {
            self.navigationController?.isNavigationBarHidden = true
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
        searchVC?.searchBar.text = self.searchBar.text
        self.navigationController?.pushViewController(searchVC!, animated: true)
    }
    
    func displayProducts(with categories: [Category]) {
        searchVC = nil
        searchVC = SearchViewController(categories: categories)
        searchVC?.searchBar.text = self.searchBar.text
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
        
        searchBarIsEditing = true
        
        if let searchText = searchBar.text {
            if searchText.isEmpty {
                searchListDataFiltered = []
            } else {
                self.searchListDataFiltered = StorageDB.getProducts().filter({ prod in return prod.product_name.lowercased().fuzzyMatch(searchText.lowercased()) })
            }
        }
        
        searchBarList.reloadData()
    }
    
    @objc
    func dismissSearchBar() {
        self.searchBarIsEditing = false
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
        searchBarIsEditing = false
    }
}

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}
