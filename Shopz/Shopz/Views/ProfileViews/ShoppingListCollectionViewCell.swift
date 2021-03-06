//
//  ShoppingListCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ShoppingListCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let cellID = "ShoppingListContainerCell"
    
    var delegate: ShoppingListCellDelegate?
    
    let shoppingListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor.appTextColor
        label.text = "Shopping Lists"
        return label
    }()
    
    let addShoppingListButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.appTextColor
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.bounces = false
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
        addShoppingListButton.addTarget(self, action: #selector(onAddClick), for: .touchUpInside)
        contentView.addSubview(collectionView)
        contentView.addSubview(shoppingListLabel)
        contentView.addSubview(addShoppingListButton)
        contentView.backgroundColor = UIColor.thumbNailColor
        
        NSLayoutConstraint.activate([
            shoppingListLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            shoppingListLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            addShoppingListButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            addShoppingListButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: shoppingListLabel.bottomAnchor, constant: 10),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingListData?.shoppingLists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListSubCollectionViewCell.cellID, for: indexPath) as! ShoppingListSubCollectionViewCell
        cell.listDetails = shoppingListData?.shoppingLists[indexPath.row]
        cell.cellFrame = self.collectionView.frame
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            let editAction = UIAction(title: NSLocalizedString("Rename List", comment: ""), image: UIImage(systemName: "pencil")) {
                action in
                self.delegate?.rename(list: self.shoppingListData?.shoppingLists[indexPath.row])
            }
            let deleteAction = UIAction(title: NSLocalizedString("Delete List", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive) {
                action in
                self.delegate?.delete(list: self.shoppingListData?.shoppingLists[indexPath.row])
            }
            return UIMenu(title: "Edit shopping list" , children: [editAction, deleteAction]) 
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.listItemClicked(indexPath: indexPath, shoppingListData:  shoppingListData?.shoppingLists[indexPath.row])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: Int(cellFrame.width), height: (shoppingListData?.shoppingLists.count ?? 1)*100 + 150)
        return attr
    }
    
    @objc
    func onAddClick() {
        delegate?.addClicked()
    }
    
}

protocol ShoppingListCellDelegate {
    func addClicked()
    func rename(list: ShoppingList?)
    func delete(list: ShoppingList?)
    func listItemClicked(indexPath: IndexPath, shoppingListData: ShoppingList?)
}
