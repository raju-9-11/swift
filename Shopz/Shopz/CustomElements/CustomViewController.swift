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
    
    var searchListDataFiltered: [Product] = [] {
        willSet {
            self.searchBarList.frame.size.height = min(CGFloat(self.searchListDataFiltered.count*50), self.view.frame.height*0.8)
        }
    }
    
    var lvc: LoginViewController?
    
    let maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBarList: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "background_coloras")
        tv.register(SearchbarTableViewCell.self, forCellReuseIdentifier: SearchbarTableViewCell.cellID)
        tv.isScrollEnabled = false
        return tv
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        
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
            self.searchListDataFiltered = StorageDB.getProducts().filter({ prod in return prod.product_name.fuzzyMatch(searchText) })
        }
        
        searchBarList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        displayProducts(with: self.searchListDataFiltered)
        self.dismissSearchBar()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBarList.frame = self.view.frame
        searchBarList.frame.origin.y = self.searchBar.frame.origin.y + self.searchBar.frame.height
        searchBarList.frame.size.height = 0
        self.view.addSubview(maskView)
        self.view.addSubview(searchBarList)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar)))
        NSLayoutConstraint.activate([
            maskView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            maskView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            maskView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            maskView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
        if let searchText = searchBar.text {
            if searchText.isEmpty {
                searchListDataFiltered = []
            } else {
                self.searchListDataFiltered = StorageDB.getProducts().filter({ prod in return prod.product_name.fuzzyMatch(searchText) })
            }
        }
        
        searchBarList.reloadData()
    }
    
    @objc
    func dismissSearchBar() {
        searchBar.resignFirstResponder()
        searchBarList.removeFromSuperview()
        maskView.removeFromSuperview()
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
        self.dismissSearchBar()
    }
}
