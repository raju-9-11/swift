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
    lazy var popularItems: [ ItemThumbNailModel ]  = {
        return [ItemThumbNailModel(name: "Vivo Y21", id: 0, media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg"), ItemThumbNailModel(name: "Smart watch", id: 1, media: "https://m.media-amazon.com/images/I/61OUIIXnPqL._AC_SX522_.jpg"), ItemThumbNailModel(name: "Iphone 13", id: 0, media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000")]
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
    
    let popCellID = "PopCellID"
    
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
    
    let categories: [ItemThumbNailModel] = {
        return [ ItemThumbNailModel(name: "Mobile", id: 0, media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg"), ItemThumbNailModel(name: "Ear Phones", id: 1, media: "https://5.imimg.com/data5/CD/JV/NH/SELLER-3057075/phone-earphone-500x500.jpg"), ItemThumbNailModel(name: "Smart Watches", id: 2, media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000"), ItemThumbNailModel(name: "Speakers", id: 3, media: "https://d287ku8w5owj51.cloudfront.net/images/products/hero/creative-t15-wireless/hero-creative-t15-wireless.jpg?width=750"), ItemThumbNailModel(name: "Accessories", id: 4, media: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/satechi-accessories-1608141402.jpg?crop=1.00xw:0.502xh;0,0.455xh&resize=1200:*")]
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popCellID, for: indexPath) as! ItemThumbNailCollectionViewCell
        cell.data = collectionView == popularItemsList ? popularItems[indexPath.row] : categories[indexPath.row]
        return cell
    }
    
    
    // MARK: - Layout and other functions
    override func setupLayout() {
        self.title = "Home"
        view.backgroundColor = .white
        
        popularItemsList.delegate = self
        popularItemsList.dataSource = self
        popularItemsList.register(ItemThumbNailCollectionViewCell.self, forCellWithReuseIdentifier: popCellID)
        
        categoryList.delegate = self
        categoryList.dataSource = self
        categoryList.register(ItemThumbNailCollectionViewCell.self, forCellWithReuseIdentifier: popCellID)
        
        
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

