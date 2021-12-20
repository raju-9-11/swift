//
//  ProductViewCellCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class ProductViewCellCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ProductImageView"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var data: UIImage? = UIImage(systemName: "home.fill") {
        willSet {
            imageView.image = newValue
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}
