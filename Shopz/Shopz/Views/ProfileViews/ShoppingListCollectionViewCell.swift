//
//  ShoppingListCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ShoppingListCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let cellID = "ShoppingListContainerCell"
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let shoppingListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shopping Lists"
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ShoppingListSubCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingListSubCollectionViewCell.cellID)
        cv.backgroundColor = .clear
        return cv
    }()
    
    var cellFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    var shoppingListData: ShoppingListData? {
        willSet {
            if newValue != nil {
                self.collectionView.reloadData()
                self.setupLayout()
            }
        }
    }
    
    func setupLayout() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        contentView.addSubview(collectionView)
        contentView.addSubview(shoppingListLabel)
        
        NSLayoutConstraint.activate([
            shoppingListLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            shoppingListLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: shoppingListLabel.bottomAnchor),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingListData?.shoppingLists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListSubCollectionViewCell.cellID, for: indexPath) as! ShoppingListSubCollectionViewCell
//        cell.listDetails = shoppingListData?.shoppingLists[indexPath.row]
        return cell
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame.width - 2, height: 400)
        return attr
    }
    
}
