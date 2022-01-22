//
//  SearchItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        willSet {
            UIView.animate(withDuration: 4 ) {
                self.contentView.backgroundColor = newValue ? .gray : .clear
                self.nameLabel.textColor = newValue ? .white : .black
                self.costLabel.textColor = newValue ? .white : .darkGray
            }
        }
    }
    
    static let cellID = "SearchListItem"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.backgroundColor = .black
        label.font = .italicSystemFont(ofSize: 15)
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
        label.textColor = .darkGray
        label.font = .italicSystemFont(ofSize: 16)
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 10)
        label.text = "0.0/5.0"
        return label
    }()
    
    var data: Product = Product(product_id: 0, product_name: "", seller_id: 0, image_media: [], shipping_cost: 0, description: "", price: 0, rating: 0, category: "") {
        willSet {
            nameLabel.text = newValue.product_name
            costLabel.text = "$ \(newValue.price)"
            imageView.image = UIImage(systemName: newValue.image_media[0])
            ratingLabel.text = "\(newValue.rating)/5.0"
            self.setupLayout()
        }
    }
    
    
    
    func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(bottomLine)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -5),
            ratingLabel.rightAnchor.constraint(equalTo: bottomLine.rightAnchor, constant: -10),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.8),
            bottomLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            bottomLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
}
