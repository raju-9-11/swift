//
//  CategoryAddCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 13/01/22.
//

import UIKit

class CategoryAddCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CategoryAddITemCell"
    
    var delegate: CategoryAddItemDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .heavy)
        label.text = "Add Category"
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let customBackgroundView: ContainerView = {
        let view = ContainerView()
        view.backgroundColor = .red.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cellSize = CGSize(width: 100, height: 10)
    
    var categoryData = Category(id: 0, name: "PLACEHOLDER", media: "") {
        willSet {
            nameLabel.text = newValue.name
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        contentView.addSubview(customBackgroundView)
        contentView.addSubview(nameLabel)
        customBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAddCategory)))
        
        NSLayoutConstraint.activate([
            customBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            customBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            customBackgroundView.widthAnchor.constraint(equalTo: nameLabel.widthAnchor, multiplier: 1, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        self.layoutIfNeeded()
    }
    
    @objc
    func onAddCategory() {
        delegate?.addCategory()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellSize
        attr.size.width = customBackgroundView.frame.width
        return attr
    }
}

protocol CategoryAddItemDelegate {
    func addCategory()
}

class ContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height * 0.4
    }
}
