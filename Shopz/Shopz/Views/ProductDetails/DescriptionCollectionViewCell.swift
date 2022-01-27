//
//  DescriptionCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
    
    static let cellID = "DescriptionCell"
    
    var delegate: DescriptionCellDelegate?
    
    var cellFrame = CGSize(width: 100, height: 100)
    
    let titleLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.isSelectable = false
        label.isEditable = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.contentMode = .center
        label.textAlignment = .center
        label.isScrollEnabled = false
        label.textColor = UIColor(named: "text_color")
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let costlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "subtitle_text")
        label.text = "$50"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "4.4/5"
        label.textColor = UIColor(named: "subtitle_text")
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.font = .italicSystemFont(ofSize: 10)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor(named: "subtitle_text")
        textView.text = "PLACEHOLDER"
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.font = .italicSystemFont(ofSize: 12)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let soldByLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SOLD BY "
        return label
    }()
    
    let sellerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Unknown", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let addToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(UIColor(named: "text_color"), for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.baseBackgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            config.cornerStyle = .medium
            button.configuration = config
        } else {
            button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.layer.cornerRadius = 6
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        return button
    }()
    
    let buyNow: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buy Now", for: .normal)
        button.setTitleColor(UIColor(red: 0.91, green: 0.051, blue: 0.322, alpha: 1), for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.baseBackgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            config.cornerStyle = .medium
            button.configuration = config
        } else {
            button.backgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            button.layer.cornerRadius = 6
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        return button
    }()
    
    let costRatings: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.axis = .horizontal
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonsView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 5
        view.axis = .horizontal
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sellerView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillProportionally
        view.spacing = 0
        view.axis = .horizontal
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var data: DescriptionElement? {
        willSet {
            if newValue != nil {
                titleLabel.text = newValue!.title
                textView.text = newValue!.description
                ratingsLabel.text = "\(newValue!.rating)/5.0"
                costlabel.text = "$ \(newValue!.cost)"
                if newValue?.seller != nil {
                    sellerButton.setTitle(newValue!.seller!.seller_name, for: .normal)
                }
            }
            self.setupLayout()
        }
    }
    
    
    func setupLayout() {
        sellerButton.addTarget(self, action: #selector(onSellerClick), for: .touchUpInside)
        costRatings.addArrangedSubview(costlabel)
        costRatings.addArrangedSubview(ratingsLabel)
        contentView.backgroundColor = .clear
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        addToCart.addInteraction(contextMenuInteraction)
        addToCart.addTarget(self, action: #selector(onAddToCart), for: .touchUpInside)
        buyNow.addTarget(self, action: #selector(onBuy), for: .touchUpInside)
        if Auth.auth != nil {
            buttonsView.addArrangedSubview(addToCart)
            buttonsView.addArrangedSubview(buyNow)
        }
        sellerView.addArrangedSubview(soldByLabel)
        sellerView.addArrangedSubview(sellerButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(costRatings)
        contentView.addSubview(sellerView)
        contentView.addSubview(buttonsView)
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            costRatings.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            costRatings.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            costRatings.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: costRatings.bottomAnchor, constant: 10),
            buttonsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sellerView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 10),
            sellerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textView.topAnchor.constraint(equalTo: sellerButton.bottomAnchor),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        self.layoutIfNeeded()
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
            suggActions in
            let shoppingLists = ApplicationDB.shared.getShoppingLists()
            let menu = shoppingLists.map({ list in return UIAction(
                title: list.name,
                image: UIImage(systemName: "heart.fill"),
                handler: { _ in
                    self.delegate?.addToShoppingList(list: list)
                    
                })
            })
            return UIMenu(title: "Add to Shopping List" , children: menu)
            
        })
    }
    
    @objc
    func onAddToCart() {
        delegate?.addToCartClicked()
    }
    
    @objc
    func onBuy() {
        delegate?.buyClicked()
    }
    
    @objc
    func onSellerClick() {
        if data != nil, data?.seller != nil {
            delegate?.displaySeller(sellerData: data!.seller!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buyNow.removeFromSuperview()
        addToCart.removeFromSuperview()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        let frameHeight = textView.frame.height + titleLabel.frame.height + buttonsView.frame.height + 100
        attr.size = CGSize(width: cellFrame.width, height: frameHeight)
        return attr
    }
   
}

protocol DescriptionCellDelegate {
    func displaySeller(sellerData: Seller)
    func buyClicked()
    func addToCartClicked()
    func addToShoppingList(list: ShoppingList)
}
