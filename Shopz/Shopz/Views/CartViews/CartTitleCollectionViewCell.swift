//
//  TitleCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 03/01/22.
//

import UIKit

class CartTitleCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "CartCVTitleCELL"
    
    
    var title: String = "Cart" {
        willSet {
            self.titleLabel.text = newValue
            self.setupLayout()
        }
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
        label.textColor = UIColor.appTextColor
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        super.removeViews()
    }
    
    
    
}
