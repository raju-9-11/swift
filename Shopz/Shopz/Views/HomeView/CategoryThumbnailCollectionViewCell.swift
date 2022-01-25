//
//  CategoryThumbnailCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 11/01/22.
//

import UIKit

class CategoryThumbnailCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CategoryItemThumCell"
    
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
        label.textColor = UIColor(named: "thumbnail_text_color")
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.text = "Text"
        return label
    }()
    
    lazy var data: Category = Category(id: 0, name: "TEST", media: "TEST") {
        willSet {
            self.downloadImage(url: newValue.media)
            self.label.text = newValue.name
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
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
