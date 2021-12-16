//
//  CartItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 16/12/21.
//

import UIKit

class CartItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "CartItemCell"
    
    var delegate: CartItemDelegate?
    
    var itemData: ItemData? {
        willSet {
            if newValue != nil {
                nameLabel.text = newValue?.name
                costLabel.text = "$ \(newValue?.cost ?? 0) "
                self.setupLayout()
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item name"
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 20"
        label.textColor = .systemGray2
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.square")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])
    }
    
    @objc
    func onDelete() {
        guard let itemData = self.itemData else { return }
        delegate?.removeItem(itemData: itemData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    
}

protocol CartItemDelegate {
    func removeItem(itemData: ItemData)
}
