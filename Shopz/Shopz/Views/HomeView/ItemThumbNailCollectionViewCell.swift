//
//  ItemThumbNailCollectionViewcellCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ItemThumbNailCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ItemThumCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo.fill")
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.text = "Text"
        return label
    }()
    
    lazy var data: Product = Product(product_id: 0, product_name: "", seller_id: 0, image_media: "", shipping_cost: 0.0, description: "", price: 0.0, rating: 0.0, category: "") {
        willSet {
            self.downloadImage(url: newValue.image_media)
            self.label.text = newValue.product_name
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 1
        
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func downloadImage(url: String) {
        
    }
    
}
