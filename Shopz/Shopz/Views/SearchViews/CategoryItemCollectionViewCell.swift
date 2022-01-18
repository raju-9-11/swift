//
//  CategoryItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CategoryITemCell"
    
    var delegate: CategoryItemDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .heavy)
        label.text = "PLACEHOLDER"
        return label
    }()
    
    let closeButton: RoundedButton = {
        let button = RoundedButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        button.backgroundColor = .white
        return button
    }()
    
    let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 5
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let customBackgroundView: ContainerView = {
        let view = ContainerView()
        view.backgroundColor = .blue.withAlphaComponent(0.5)
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
        containerView.addArrangedSubview(nameLabel)
        containerView.addArrangedSubview(closeButton)
        closeButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        contentView.addSubview(customBackgroundView)
        contentView.addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            customBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            customBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customBackgroundView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1, constant: 10),
            customBackgroundView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1, constant: 15),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        self.layoutIfNeeded()
    }
    
    @objc
    func onDelete() {
        delegate?.removeCategory(category: self.categoryData)
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

protocol CategoryItemDelegate {
    func removeCategory(category: Category)
}


class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
