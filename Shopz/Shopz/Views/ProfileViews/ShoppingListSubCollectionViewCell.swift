//
//  ShoppingListSubCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ShoppingListSubCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ShoppingListCell"
    
    var cellFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Shopping List"
        return label
    }()
    
    var listDetails: ShoppingList? {
        willSet {
            if newValue != nil {
                nameLabel.text = newValue?.name
                self.setupLayout()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    func setupLayout() {
        containerView.addSubview(nameLabel)
        containerView.addSubview(imageView)
        
        containerView.layer.cornerRadius = 6
        containerView.backgroundColor = .systemGray6
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.leftAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leftAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    
}
