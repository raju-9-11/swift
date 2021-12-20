//
//  SearchItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "SearchListItem"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var data: ItemData = ItemData(name: "", media: "", cost: 0) {
        willSet {
            nameLabel.text = newValue.name
            costLabel.text = "$ \(newValue.cost)"
            imageView.image = UIImage(systemName: newValue.media)
            self.setupLayout()
        }
    }
    
    
    
    func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
            bottomLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            bottomLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
}
