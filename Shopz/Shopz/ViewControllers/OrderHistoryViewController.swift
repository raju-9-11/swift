//
//  CartViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class OrderHistoryViewController: CustomViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, OrderHistoryItemDelegate {
    
    var listItems: [OrderHistItem] = [] {
        willSet {
            self.collectionView.isHidden = newValue.isEmpty
            self.placeholderView.isHidden = !newValue.isEmpty
        }
    }
    
    var prodVC: ProductViewController?

    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prodVC = nil
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.requiresAuth = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ){
            self.setupLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getList() -> [OrderHistItem] {
        let list = ApplicationDB.shared.getOrderHistory()
        return list
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
    
    @objc
    func onLogout() {
        self.removeViews()
    }
    
    @objc
    func onLogin() {
        self.setupLayout()
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
    
    func addReview(item: Product) {
        if prodVC == nil {
            prodVC = ProductViewController()
            prodVC?.productData = item
        }
        prodVC!.removeViews()
        prodVC!.setupLayout()
        prodVC!.productData = item
        self.addChild(prodVC!)
        self.willMove(toParent: self)
        self.view.addSubview(prodVC!.view)
    }
    
    func returnProduct(item: OrderHistItem) {
        print("Returning \(item.product.product_name)...")
    }
    
}

