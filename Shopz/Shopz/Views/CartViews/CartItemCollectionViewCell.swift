//
//  CartItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 16/12/21.
//

import UIKit
import Combine

class CartItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "CartItemCell"
    
    var delegate: CartItemDelegate?
    var cancellable: AnyCancellable?
    
    var itemData: CartItem? {
        willSet {
            if newValue != nil {
                countLabel.text = "\(newValue!.count)"
                nameLabel.text = newValue?.product.product_name
                costLabel.text = "$ \(newValue?.product.price ?? 0) "
                self.cancellable = self.loadImage(for: newValue!.product.image_media[0]).sink(receiveValue: {
                    [unowned self] image in
                    self.imageView.image = image
                })
                self.setupLayout()
            }
        }
    }
    
    let countLabel: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.isEnabled = false
        return textField
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item name"
        label.textColor = UIColor.appTextColor
        label.numberOfLines = 2
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 20"
        label.textColor = UIColor.subtitleTextColor
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
    
    let bottomLine: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 1
        view.backgroundColor = UIColor.appTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.square")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        return button
    }()
    
    lazy var countStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addButton, countLabel, removeButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(countStack)
        contentView.backgroundColor = UIColor.thumbNailColor
        
        addButton.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(onRemove), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -5),
            closeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -20),
//            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            countLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            countStack.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            countStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: url)!
                return ImageLoader.shared.loadImage(from: url)
                
            })
           .eraseToAnyPublisher()
    }
    
    @objc
    func onDelete() {
        guard let itemData = self.itemData else { return }
        delegate?.deleteProduct(item: itemData)
    }
    
    @objc
    func onAdd() {
        guard let itemData = self.itemData else { return }
        delegate?.addItem(item: itemData)
//        self.countLabel.text = "\(itemData.count + 1)"
    }
    
    @objc
    func onRemove() {
        guard let itemData = self.itemData else { return }
        delegate?.removeItem(item: itemData)
//        self.countLabel.text = "\(itemData.count - 1)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        self.removeViews()
    }
    
    
}

protocol CartItemDelegate {
    func removeItem(item: CartItem)
    func addItem(item: CartItem)
    func deleteProduct(item: CartItem)
}
