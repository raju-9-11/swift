//
//  CartViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class OrderHistoryViewController: CustomViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, OrderHistoryItemDelegate {
    
    override var auth: Auth? {
        willSet {
            self.removeViews()
            self.setupLayout()
        }
    }
    
    var listItems: [ItemData] = [] {
        willSet {
            self.collectionView.isHidden = newValue.isEmpty
            self.placeholderView.isHidden = !newValue.isEmpty
        }
    }
    
    let prodVC = ProductViewController()

    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(OrderHistoryItemCollectionViewCell.self, forCellWithReuseIdentifier: OrderHistoryItemCollectionViewCell.cellID)
        cv.register(CartTitleCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CartTitleCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isHidden = true
        return cv
    }()
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "No Items Bought yet"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: UIImage(named: "EmptyCart"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.topAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 50),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        ])
        view.backgroundColor = .white
        return view
    }()
    
    let cvc = CheckoutViewController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, auth: Auth?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.auth = auth
        self.requiresAuth = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (requiresAuth && auth != nil) || ( !requiresAuth ){
            self.setupLayout()
        }
    }
    
    func getList() -> [ItemData] {
        let cart = [
            ItemData(name: "samsung y12", media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg", cost: 22),
            ItemData(name: "samsung y12", media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg", cost: 22),
            ItemData(name: "samsung y12", media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg", cost: 22),
            ItemData(name: "samsung y12", media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg", cost: 22),
            ItemData(name: "samsung y12", media: "https://sathya.in/media/55438/catalog/vivo-mobile-y21-midnight-blue4gb-ram128gb-storage-3.jpg", cost: 22),
        ]
        return cart
    }
    
    func getCart() -> [ItemData] {
        let shoppingList = [
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
            ItemData(name: "Iphone", media: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1631652956000", cost: 33),
        ]
        return shoppingList
    }
    
    override func setupLayout() {
        
        view.backgroundColor = .white
        self.loadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        
        view.addSubview(placeholderView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func loadData() {
        self.listItems = getList()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderHistoryItemCollectionViewCell.cellID, for: indexPath) as! OrderHistoryItemCollectionViewCell
        cell.itemData = listItems[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CartTitleCollectionViewCell.cellID, for: indexPath) as! CartTitleCollectionViewCell
        headerView.title = "Order History"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 2, height: 120)
    }
    
    func addReview(item: ItemData) {
        prodVC.removeViews()
        prodVC.setupLayout()
        prodVC.productData = item
        self.addChild(prodVC)
        self.willMove(toParent: self)
        self.view.addSubview(prodVC.view)
    }
    
    func returnProduct(item: ItemData) {
        print("Returning \(item.name)...")
    }
    
    
    @objc
    func onCheckout() {
        cvc.willMove(toParent: self)
        self.addChild(cvc)
        self.view.addSubview(cvc.view)
    }
    
}

