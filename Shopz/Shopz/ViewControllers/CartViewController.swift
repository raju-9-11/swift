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
        willSet {
            if newValue != nil {
                self.listItems = getList()
                self.cartTitle = newValue?.name ?? "Untitled"
                buttonsView = .all
                label.text = "\(self.cartTitle) is Empty"
                collectionView.reloadData()
            }
        }
    }
    
    lazy var listItems: [ItemData] = getCart() {
        willSet {
            self.tabBarItem.badgeValue = "\(newValue.count)"
            if newValue.isEmpty {
                self.collectionView.isHidden = true
                self.placeholderView.isHidden = false
            } else {
                self.collectionView.isHidden = false
                self.placeholderView.isHidden = true
            }
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
        view.isHidden = true
        return view
    }()
    
    var cartViewItems: [CartViewItem] {
        get {
            var items: [CartViewItem] = []
            self.listItems.forEach({ item in items.append(CartItemViewItem(itemData: item))})
            return [CartTitleViewItem(titleName: self.cartTitle)] + items + [CartButtonsViewItem(state: .checkout)]
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        cv.register(CartItemCollectionViewCell.self, forCellWithReuseIdentifier: CartItemCollectionViewCell.cellID)
        cv.register(CartTitleCollectionViewCell.self, forCellWithReuseIdentifier: CartTitleCollectionViewCell.cellID)
        cv.register(CartButtonsCollectionViewCell.self, forCellWithReuseIdentifier: CartButtonsCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let cvc = CheckoutViewController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        DispatchQueue.main.async {
            self.tabBarItem.badgeValue = "\(self.listItems.count)"
        }
        self.requiresAuth = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
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
        
        collectionView.dataSource = self
        collectionView.delegate = self

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartViewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cartViewItems[indexPath.row] {
        case let item as CartItemViewItem :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemCollectionViewCell.cellID, for: indexPath) as! CartItemCollectionViewCell
            cell.itemData = item
            cell.delegate = self
            return cell
        case _ as CartButtonsViewItem:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartButtonsCollectionViewCell.cellID, for: indexPath) as! CartButtonsCollectionViewCell
            cell.state = buttonsView
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartTitleCollectionViewCell.cellID, for: indexPath) as! CartTitleCollectionViewCell
            cell.title = cartTitle
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cartViewItems[indexPath.row] {
        case _ as CartTitleViewItem :
            return CGSize(width: collectionView.frame.width - 2, height: 50)
        case _ as CartButtonsViewItem:
            return CGSize(width: collectionView.frame.width - 2, height: 50)
        default:
            return CGSize(width: collectionView.frame.width - 2, height: 100)
        }
    }
    
    func removeItem(item: CartItemViewItem) {
        for (index, listItem ) in cartViewItems.enumerated() {
            guard let listItem = listItem as? CartItemViewItem else { continue }
            if item.itemData.id == listItem.itemData.id {
                listItems.remove(at: index - 1)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                self.collectionView.reloadData()
                break
            }
        }
    }
    
    func updateCart() {
        print("Updating Cart")
    }
    
    @objc
    func onCheckout() {
        cvc.willMove(toParent: self)
        self.addChild(cvc)
        self.view.addSubview(cvc.view)
    }
    
    func onDelete() {
        self.listItems.removeAll()
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}

class CartViewItem {
    let uuid = UUID()
}

class CartTitleViewItem : CartViewItem {
    var titleName: String = "Cart"
    init(titleName: String ) {
        self.titleName = titleName
    }
}

class CartItemViewItem: CartViewItem {
    var itemData: ItemData
    init(itemData: ItemData) {
        self.itemData = itemData
    }
}

class CartButtonsViewItem: CartViewItem {
    var state: ButtonsViewState
    init(state: ButtonsViewState) {
        self.state = state
    }
}

struct ItemData {
    var id = UUID()
    var name: String
    var media: String
    var cost: Double
    var rating: Double = 0
}
