//
//  CategoryItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CategoryITemCell"
    
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
    
    let containerView: ContainerView = {
        let view = ContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cellSize = CGSize(width: 100, height: 10)
    
    var categoryData = CategoryData(name: "PLACEHOLDER") {
        willSet {
            nameLabel.text = newValue.name
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        containerView.addSubview(nameLabel)
        containerView.addSubview(closeButton)
        contentView.addSubview(containerView)
        containerView.backgroundColor = .blue.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            closeButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            closeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellSize
        attr.size.width = max(CGFloat(categoryData.name.count)*10 + 40, 100)
        return attr
    }
}

class CategoryData {
    var id = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class ContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
