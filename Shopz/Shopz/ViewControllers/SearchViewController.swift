//
//  SearchViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 16/12/21.
//

import UIKit

class SearchViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override var auth: Auth? {
        willSet {
            self.removeViews()
            self.setupLayout()
        }
    }
   
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
    
    let pvc = ProductViewController()
    
    let categoryList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.register(CategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    var searchListData: [Product] = StorageDB.getProducts() {
        willSet {
            
        }
    }
    
    var categoryListData: [Category] = StorageDB.getCategories() {
        willSet {
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, auth: Auth?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.auth = auth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (requiresAuth && auth != nil) || ( !requiresAuth ){
            self.setupLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == searchList ? searchListData.count : categoryListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.cellID, for: indexPath) as! CategoryItemCollectionViewCell
            cell.categoryData = categoryListData[indexPath.row]
            cell.cellSize = CGSize(width: collectionView.frame.width - 2, height: collectionView.frame.height - 2)
            return cell
            
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.cellID, for: indexPath) as! SearchItemCollectionViewCell
        cell.data = searchListData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchList {
            pvc.productData = searchListData[indexPath.row]
            pvc.willMove(toParent: self)
            self.addChild(pvc)
            self.view.addSubview(pvc.view)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 2, height: 100)
    }
    
    
    override func setupLayout() {
        view.backgroundColor = .white
        searchList.dataSource = self
        searchList.delegate = self
        
        categoryList.dataSource = self
        categoryList.delegate = self
        
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
    
}
