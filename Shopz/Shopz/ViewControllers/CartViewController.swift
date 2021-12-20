//
//  CartViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class CartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CartItemDelegate {
    
    var cartTitle: String = "Cart"
    
    var listDetails: ShoppingList? {
        willSet {
            if newValue != nil {
                self.listItems = getList()
                self.titleLabel.text = newValue?.name
                self.buttonsView.addArrangedSubview(deleteList)
            }
        }
    }
    
    lazy var listItems: [ItemData] = getCart() {
        willSet {
            if newValue.isEmpty {
                UIView.animate(withDuration: 4 ) {
                    self.buttonsView.isHidden = true
                }
            } else {
                buttonsView.isHidden = false
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CartItemCollectionViewCell.self, forCellWithReuseIdentifier: CartItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let checkout: UIButton = {
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.layer.cornerRadius = 6
        }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let deleteList: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Shopping List", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.backgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            button.layer.cornerRadius = 6
        }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let cvc = CheckoutViewController()
    
    lazy var buttonsView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [checkout])
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        checkout.addTarget(self, action: #selector(onCheckout), for: .touchUpInside)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
        containerView.addSubview(buttonsView)
        view.addSubview(containerView)
        
        
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
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.95),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.heightAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85),
            collectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            collectionView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            buttonsView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            buttonsView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
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
    
    func removeItem(itemData: ItemData) {
        for (index, item ) in listItems.enumerated() {
            if item.id == itemData.id {
                listItems.remove(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                break
            }
        }
        self.collectionView.reloadData()
    }
    
    @objc
    func onCheckout() {
        cvc.willMove(toParent: self)
        self.addChild(cvc)
        self.view.addSubview(cvc.view)
        cvc.displayFullScreen(on: self.view)
    }
    
}

struct ItemData {
    var id = UUID()
    var name: String
    var media: String
    var cost: Double
}
