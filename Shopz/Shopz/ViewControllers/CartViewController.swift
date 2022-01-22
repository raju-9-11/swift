//
//  CartViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class CartViewController: CustomViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CartItemDelegate, ButtonsViewDelegate {
    
    var cartTitle: String = "Cart"
    var buttonsView: ButtonsViewState = .checkout
    
    var listDetails: ShoppingList? {
        didSet {
            if listDetails != nil {
                self.cartTitle = listDetails?.name ?? "Untitled"
                buttonsView = .all
                label.text = "\(self.cartTitle) is Empty"
            }
            self.loadData()
        }
    }
    
    lazy var listItems: [Product] = [] {
        willSet {
            self.tabBarItem.badgeValue = "\(newValue.count)"
            self.collectionView.isHidden = newValue.isEmpty
            self.placeholderView.isHidden = !newValue.isEmpty
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Cart is Empty"
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
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        cv.register(CartItemCollectionViewCell.self, forCellWithReuseIdentifier: CartItemCollectionViewCell.cellID)
        cv.register(CartTitleCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CartTitleCollectionViewCell.cellID)
        cv.register(CartButtonsCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CartButtonsCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isHidden = true
        return cv
    }()
    
    var cvc: CheckoutViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        DispatchQueue.main.async {
            if Auth.auth != nil {
                self.tabBarItem.badgeValue = "\(self.listItems.count)"
            }
        }
        self.requiresAuth = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogin), name: .userLogin, object: nil)
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ) 	{
            self.setupLayout()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        cvc = nil
    }
    
    
    func getList() -> [Product] {
        let shoppingList = ApplicationDB.shared.getCart()
        return shoppingList
    }
    
    func getCart() -> [Product] {
        let cart = ApplicationDB.shared.getCart()
        return cart
    }
    
    override func setupLayout() {
        view.backgroundColor = .white
        self.loadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout) {
            layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
            layout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        }

        view.addSubview(collectionView)
        view.addSubview(placeholderView)
        
        self.tabBarItem.badgeValue = "\(listItems.count)"
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            placeholderView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
    }
    
    @objc
    func onLogout() {
        self.tabBarItem.badgeValue = nil
        self.removeViews()
    }
    
    @objc
    func onLogin() {
        self.tabBarItem.badgeValue = "\(listItems.count)"
        self.setupLayout()
    }
    
    func loadData() {
        if listDetails != nil {
            self.listItems = getList()
        }
        self.listItems = getCart()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCollectionViewCell.cellID, for: indexPath) as! CartItemCollectionViewCell
        cell.itemData = listItems[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CartButtonsCollectionViewCell.cellID, for: indexPath) as! CartButtonsCollectionViewCell
            headerView.delegate = self
            headerView.state = buttonsView
            return headerView
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CartTitleCollectionViewCell.cellID, for: indexPath) as! CartTitleCollectionViewCell
        headerView.title = cartTitle
        return headerView
    }
    
    func removeItem(item: Product) {
        for (index, listItem ) in listItems.enumerated() {
            if item.product_id == listItem.product_id {
                listItems.remove(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                break
            }
        }
    }
    
    func updateCart() {
        print("Updating Cart")
        self.collectionView.reloadData()
    }
    
    @objc
    func onCheckout() {
        if cvc == nil {
            cvc = CheckoutViewController()
        }
        cvc!.willMove(toParent: self)
        self.addChild(cvc!)
        self.view.addSubview(cvc!.view)
    }
    
    func onDelete() {
        self.listItems.removeAll()
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
