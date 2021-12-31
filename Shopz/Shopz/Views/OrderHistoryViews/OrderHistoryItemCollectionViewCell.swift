//
//  OrderHistoryItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class OrderHistoryItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "OrderHistoryItemCell"
    
    var delegate: OrderHistoryItemDelegate?
    
    var itemData: ItemData? {
        willSet {
            if newValue != nil {
                nameLabel.text = newValue?.name
                costLabel.text = "$ \(newValue?.cost ?? 0) "
                self.setupLayout()
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item name"
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 20"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGray2
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let addReview: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Review", for: .normal)
        button.tintColor = .systemRed
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 6
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(red: 0.933, green: 0.502, blue: 0.502, alpha: 1)
        return button
    }()
    
    let returnProduct: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Return Product", for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.backgroundColor = .systemRed
        return button
    }()
    
    
    lazy var buttonsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addReview, returnProduct])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        stackView.contentMode = .scaleAspectFit
        return stackView
    }()


    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(buttonsView)
        addReview.addTarget(self, action: #selector(onAddReview), for: .touchUpInside)
        returnProduct.addTarget(self, action: #selector(onReturn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            buttonsView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            buttonsView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
    
    @objc
    func onAddReview() {
        guard let itemData = self.itemData else { return }
        delegate?.addReview(item: itemData)
    }
    
    @objc
    func onReturn() {
        guard let itemData = self.itemData else { return }
        delegate?.returnProduct(item: itemData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    
}

protocol OrderHistoryItemDelegate {
    func addReview(item: ItemData)
    func returnProduct(item: ItemData)
}
