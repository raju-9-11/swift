//
//  ItemThumbNailCollectionViewcellCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 13/12/21.
//

import UIKit

class ItemThumbNailCollectionViewCell: UICollectionViewCell {
    
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
    
    lazy var data: ItemThumbNailModel = ItemThumbNailModel(name: "TEST", id: 0, media: "TEST") {
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
        ])
    }
    
    func downloadImage(url: String) {
        
    }
    
}
