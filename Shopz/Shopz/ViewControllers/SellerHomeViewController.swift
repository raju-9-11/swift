//
//  ViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 07/12/21.
//

import UIKit

class SellerHomeViewController: CustomViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var sellerData: SellerData = SellerData(name: "Pacman", imageMedia: "") {
        willSet {
            self.loadData()
        }
    }
    
    // MARK: Data
    lazy var popularItems: [ Product ]  = {
        var array: [Product] = []
        StorageDB.getProducts()[0...10].forEach({ prod in array.append(prod) })
        return array
    }()
    
    
    // MARK: - UI Elements
    let popularItemsList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.bounces = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let popularItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Items"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    let popularItemsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let categoryList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let categories: [Category] = {
        return StorageDB.getCategories()
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()

    
    // MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        
    }
    
    // MARK: - CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == popularItemsList ? popularItems.count : categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryList {
            return CGSize(width: collectionView.frame.width*0.3, height: collectionView.frame.width*0.3)
        }
        return CGSize(width: collectionView.frame.height*0.95, height: collectionView.frame.height*0.95)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularItemsList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemThumbNailCollectionViewCell.cellID, for: indexPath) as! ItemThumbNailCollectionViewCell
            cell.data = popularItems[indexPath.row]
            return cell
        }
        if collectionView == categoryList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryThumbnailCollectionViewCell.cellID, for: indexPath) as! CategoryThumbnailCollectionViewCell
            cell.data = categories[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemThumbNailCollectionViewCell.cellID, for: indexPath)
        return cell
    }
    
    
    // MARK: - Layout and other functions
    override func setupLayout() {
        self.title = "Home"
        view.backgroundColor = .white
        
        popularItemsList.delegate = self
        popularItemsList.dataSource = self
        popularItemsList.register(ItemThumbNailCollectionViewCell.self, forCellWithReuseIdentifier: ItemThumbNailCollectionViewCell.cellID)
        
        categoryList.delegate = self
        categoryList.dataSource = self
        categoryList.register(CategoryThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: CategoryThumbnailCollectionViewCell.cellID)
        
        
        popularItemsView.addSubview(popularItemsList)
        popularItemsView.addSubview(popularItemsLabel)
        view.addSubview(popularItemsView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(categoryList)
        view.addSubview(categoryView)
        NSLayoutConstraint.activate([
            popularItemsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            popularItemsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popularItemsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            popularItemsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            popularItemsLabel.topAnchor.constraint(equalTo: popularItemsView.topAnchor, constant: 10),
            popularItemsLabel.leftAnchor.constraint(equalTo: popularItemsView.leftAnchor, constant: 10),
            popularItemsList.topAnchor.constraint(equalTo: popularItemsLabel.bottomAnchor, constant: 5),
            popularItemsList.centerXAnchor.constraint(equalTo: popularItemsView.centerXAnchor),
            popularItemsList.heightAnchor.constraint(equalTo: popularItemsView.heightAnchor, multiplier: 0.8),
            popularItemsList.widthAnchor.constraint(equalTo: popularItemsView.widthAnchor),
            categoryView.topAnchor.constraint(equalTo: popularItemsView.bottomAnchor, constant: 10),
            categoryView.widthAnchor.constraint(equalTo: view.widthAnchor),
            categoryView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryView.heightAnchor.constraint(equalTo: view.heightAnchor),
            categoryLabel.topAnchor.constraint(equalTo: categoryView.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoryLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
            categoryList.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            categoryList.widthAnchor.constraint(equalTo: categoryView.widthAnchor),
            categoryList.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
            categoryList.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor),
        ])
    }
    
    func loadData() {
        // Data Loading here
    }


}

