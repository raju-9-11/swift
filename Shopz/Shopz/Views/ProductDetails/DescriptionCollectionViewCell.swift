//
//  DescriptionCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "DescriptionCell"
    
    var cellFrame = CGSize(width: 100, height: 100)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.sizeToFit()
        return label
    }()
    
    let costlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$50"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "4.4/5"
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.font = .italicSystemFont(ofSize: 10)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .darkGray
        textView.text = "PLACEHOLDER"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isSecureTextEntry = true
        textView.font = .italicSystemFont(ofSize: 12)
        textView.sizeToFit()
        textView.isScrollEnabled = false
        return textView
    }()
    
    let soldByLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sold by"
        return label
    }()
    
    let sellerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Placeholder", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let addToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let buyNow: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    var data: DescriptionElement = DescriptionElement(description: "", title: "", cost: 0, rating: 0, seller: SellerData(name: "", imageMedia: "")) {
        willSet {
            titleLabel.text = newValue.title
            textView.text = newValue.description
            ratingsLabel.text = "\(newValue.rating)/5.0"
            costlabel.text = "$ \(newValue.cost)"
            sellerButton.setTitle(newValue.seller.name, for: .normal)
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        contentView.addSubview(costlabel)
        contentView.addSubview(ratingsLabel)
        contentView.addSubview(addToCart)
        contentView.addSubview(buyNow)
        contentView.addSubview(textView)
        contentView.addSubview(soldByLabel)
        contentView.addSubview(sellerButton)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            costlabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            costlabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            ratingsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            ratingsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            addToCart.topAnchor.constraint(equalTo: ratingsLabel.bottomAnchor),
            addToCart.rightAnchor.constraint(equalTo: contentView.centerXAnchor),
            buyNow.topAnchor.constraint(equalTo: ratingsLabel.bottomAnchor),
            buyNow.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
            soldByLabel.topAnchor.constraint(equalTo: buyNow.bottomAnchor),
            soldByLabel.rightAnchor.constraint(equalTo: contentView.centerXAnchor),
            sellerButton.topAnchor.constraint(equalTo: buyNow.bottomAnchor),
            sellerButton.leftAnchor.constraint(equalTo: soldByLabel.rightAnchor),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textView.topAnchor.constraint(equalTo: sellerButton.bottomAnchor),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame
        return attr
    }
   
}
