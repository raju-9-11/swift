//
//  CartViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class CartViewController: CustomViewController {
    
    var cartTitle: String = "Cart"
    var buttonsView: ButtonsViewState = .checkout
    
    var listDetails: ShoppingList? {
        didSet {
            if listDetails != nil {
                self.cartTitle = listDetails?.name ?? "Untitled"
                buttonsView = .all
                self.title = "\(self.cartTitle)"
                label.text = "\(self.cartTitle) is Empty"
            }
            self.loadData()
        }
    }
    
    weak var delegate: ShoppingListViewDelegate?
    
    var listItems: [CartItem] = [] {
        didSet {
            self.updateBadge()
            self.collectionView.isHidden = listItems.isEmpty
            self.placeholderView.isHidden = !listItems.isEmpty
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Cart is Empty"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.subtitleTextColor
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
        view.backgroundColor = .clear
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
                self.updateBadge()
            }
        }
        self.requiresAuth = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: .cartUpdate, object: nil)
        if (requiresAuth && Auth.auth != nil) || ( !requiresAuth ) 	{
            self.setupLayout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        cvc = nil
    }
    
    
    func getList() -> [CartItem] {
        guard listDetails != nil else { return [] }
        let shoppingList = ApplicationDB.shared.getShoppingList(with: listDetails!.id)
        return shoppingList
    }
    
    func getCart() -> [CartItem] {
        let cart = ApplicationDB.shared.getCart()
        return cart
    }
    
    override func setupLayout() {
        
        view.backgroundColor = UIColor.shopzBackGroundColor
        
        self.loadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout) {
            layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
            layout.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        }

        view.addSubview(collectionView)
        view.addSubview(placeholderView)
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
    override func onLogout() {
        super.onLogout()
        self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    @objc
    override func onLogin() {
        super.onLogin()
        self.updateBadge()
        self.setupLayout()
    }
    
    func loadData() {
        if listDetails != nil {
            self.listItems = getList()
            collectionView.reloadData()
            return
        }
        self.updateBadge()
        self.listItems = getCart()
        collectionView.reloadData()
    }
    
    @objc
    func updateBadge() {
        if let count = ApplicationDB.shared.getCartCount(), listDetails == nil {
            self.navigationController?.tabBarItem.badgeValue = "\(count)"
        } else {
            self.navigationController?.tabBarItem.badgeColor = nil
        }
    }
    
    @objc
    func onCheckout() {
        if cvc == nil {
            cvc = CheckoutViewController()
        }
        if listDetails == nil {
            cvc?.bind(with: listItems)
        } else {
            cvc?.bind(with: listItems, shoppingList: listDetails!)
        }
        self.navigationController?.pushViewController(cvc!, animated: true)
    }
    
}

extension CartViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.displayProduct(product: listItems[indexPath.row].product)
    }
}

extension CartViewController: CartItemDelegate, ButtonsViewDelegate {
    
    
    func addItem(item: CartItem) {
        if listDetails == nil {
            ApplicationDB.shared.addToCart(item: item.product)
            self.updateBadge()
        } else {
            ApplicationDB.shared.addToShoppingList(item: item.product, list: listDetails!)
        }
        self.loadData()
    }
    
    func onDelete() {
        self.listItems.removeAll()
        guard let listDetails = listDetails else {
            return
        }
        delegate?.deleteListClicked(list: listDetails)
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteProduct(item: CartItem) {
        if listDetails == nil {
            ApplicationDB.shared.removeFromCart(item: item.product)
            self.updateBadge()
        } else {
            ApplicationDB.shared.removeFromShoppingList(list: listDetails!, item: item.product)
        }
        for (index, listItem ) in listItems.enumerated() {
            if item.itemId == listItem.itemId {
                listItems.remove(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                break
            }
        }
        self.loadData()
    }
    
    func removeItem(item: CartItem) {
        if listDetails == nil {
            ApplicationDB.shared.removeFromCart(item: item)
            self.updateBadge()
        } else {
            ApplicationDB.shared.removeFromShoppingList(list: listDetails!, item: item)
        }
        self.loadData()
    }
    
}

protocol ShoppingListViewDelegate: AnyObject {
    func deleteListClicked(list: ShoppingList)
}
