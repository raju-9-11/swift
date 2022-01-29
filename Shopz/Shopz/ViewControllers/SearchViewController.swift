//
//  SearchViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 16/12/21.
//

import UIKit

class SearchViewController: CustomViewController, CategoryItemDelegate, CategoryAddItemDelegate, AddCategoryDelegate {
   
    let searchList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SearchItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let categoryList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.register(CategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryItemCollectionViewCell.cellID)
        cv.register(CategoryAddCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CategoryAddCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    var searchListData: [Product] = [] {
        willSet {
            
        }
    }
    
    var searchListFiltered: [Product] = [] {
        willSet {
            
        }
    }
    
    var categoryListData: [Category] = [] {
        willSet {
            if !newValue.isEmpty {
                searchListFiltered = searchListData.filter({ item in return newValue.contains { elem in return elem.name == item.category } })
            } else {
                searchListFiltered = searchListData.map({ item in return item })
            }
            DispatchQueue.main.async {
                self.searchList.reloadData()
            }
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
//            self.setupLayout()
//        }
//    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
            self.loadData()
        }
    }
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, categories: [Category]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
            self.loadData(with: categories)
        }
    }
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, products: [Product]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
            self.loadData(with: products)
        }
    }
    
    func removeCategory(category: Category) {
        for (index, val) in categoryListData.enumerated() {
            if val.id == category.id {
                self.categoryList.deleteItems(at: [IndexPath(row: index, section: 0)])
                self.categoryListData.remove(at: index)
                return
            }
        }
    }
    
    func addCategory() {
        let avc = AddCategoryVC()
        avc.categories = StorageDB.getCategories().filter({ categ in return !categoryListData.contains(where: { category in return categ.id == category.id}) })
        avc.willMove(toParent: self)
        avc.delegate = self
        self.addChild(avc)
        self.view.addSubview(avc.view)
    }
    
    func onAddCategs(_ categories: [Category]) {
        self.categoryListData.append(contentsOf: categories)
        self.categoryList.reloadData()
    }
    
    
    override func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")
        searchList.dataSource = self
        searchList.delegate = self
        
        categoryList.dataSource = self
        categoryList.delegate = self
        if let layout = categoryList.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.footerReferenceSize = CGSize(width: 100, height: categoryList.frame.height * 0.9)
        }
        
        view.addSubview(searchList)
        view.addSubview(categoryList)
        NSLayoutConstraint.activate([
            categoryList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryList.widthAnchor.constraint(equalTo: view.widthAnchor),
            categoryList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryList.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            searchList.topAnchor.constraint(equalTo: categoryList.bottomAnchor, constant: 10),
            searchList.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            searchList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.children.forEach({ child in child.view.removeFromSuperview(); child.removeFromParent()})
    }
    
    func loadData(with categories: [Category] = []) {
        self.searchListData = StorageDB.getProducts()
        self.categoryListData = categories
        categoryList.reloadData()
    }
    
    func loadData(with products: [Product]) {
        self.searchListData = products
        self.categoryListData = []
        categoryList.reloadData()
    }
    
    override func displayProducts(with products: [Product]) {
        self.loadData(with: products)
    }
    
    override func displayProducts(with categories: [Category]) {
        self.loadData(with: categories)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == searchList ? searchListFiltered.count : categoryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.cellID, for: indexPath) as! CategoryItemCollectionViewCell
            cell.categoryData = categoryListData[indexPath.row]
            cell.cellSize = CGSize(width: collectionView.frame.width - 2, height: collectionView.frame.height - 2)
            cell.delegate = self
            return cell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.cellID, for: indexPath) as! SearchItemCollectionViewCell
        cell.data = searchListFiltered[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == categoryList {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CategoryAddCollectionViewCell.cellID, for: indexPath) as! CategoryAddCollectionViewCell
            cell.setupLayout()
            cell.delegate = self
            return cell
        }
        return collectionView == categoryList ? collectionView.dequeueReusableCell(withReuseIdentifier: CategoryAddCollectionViewCell.cellID, for: indexPath) : collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.cellID, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchList {
            self.displayProduct(product: searchListFiltered[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 2, height: 100)
    }
}
