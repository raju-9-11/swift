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
        label.textColor = UIColor.appTextColor
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let costlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.subtitleTextColor
        label.text = "$50"
        return label
    }()
    
    let rating: RatingElement = {
        let rating = RatingElement()
        rating.translatesAutoresizingMaskIntoConstraints = false
        rating.isEnabled = false
        return rating
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating:"
        label.textColor = UIColor.subtitleTextColor
        label.contentMode = .left
        label.translatesAutoresizingMaskIntoConstraints = false 
        label.font = .italicSystemFont(ofSize: 10)
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.subtitleTextColor
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ex nec ultrices efficitur. Cras maximus pulvinar mi, ullamcorper bibendum arcu bibendum id. Proin interdum accumsan turpis. Quisque aliquam magna a consequat auctor. Maecenas semper tortor laoreet ipsum tincidunt, non tristique ligula molestie. Phasellus mattis nisl eget congue faucibus. Fusce diam urna, pulvinar congue vehicula in, cursus at felis."
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.font = .italicSystemFont(ofSize: 12)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let soldByLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appTextColor
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
        button.setTitleColor(.white, for: .normal)
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
    
    let shoppingListButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        button.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        button.tintColor = UIColor.appTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    let costRatings: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var data: DescriptionElement? {
        willSet {
            if newValue != nil {
                titleLabel.text = newValue!.title
                textView.text = newValue!.description
                rating.currentUserRating = Int(truncating: NSDecimalNumber(decimal: newValue!.rating))
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
        costRatings.addSubview(costlabel)
        costRatings.addSubview(rating)
        contentView.backgroundColor = .clear
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        shoppingListButton.addInteraction(contextMenuInteraction)
        if #available(iOS 15, *) {
            let menu = self.makeMenuActions()
            shoppingListButton.showsMenuAsPrimaryAction = true
            shoppingListButton.menu = UIMenu(title: "Add to Shopping List" , children: menu)
        } else {
            shoppingListButton.addTarget(self, action: #selector(onShoppingClick), for: .touchUpInside)
        }
        
        addToCart.addTarget(self, action: #selector(onAddToCart), for: .touchUpInside)
        buyNow.addTarget(self, action: #selector(onBuy), for: .touchUpInside)
        if Auth.auth != nil {
            buttonsView.addArrangedSubview(addToCart)
            buttonsView.addArrangedSubview(buyNow)
            buttonsView.addArrangedSubview(shoppingListButton)
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
            costRatings.heightAnchor.constraint(equalToConstant: 30),
            costlabel.centerYAnchor.constraint(equalTo: costRatings.centerYAnchor),
            costlabel.leftAnchor.constraint(equalTo: costRatings.leftAnchor),
            rating.rightAnchor.constraint(equalTo: costRatings.rightAnchor),
            rating.centerYAnchor.constraint(equalTo: costRatings.centerYAnchor),
            rating.heightAnchor.constraint(equalToConstant: 20),
            rating.widthAnchor.constraint(equalTo: costRatings.widthAnchor, multiplier: 0.5),
            buttonsView.topAnchor.constraint(equalTo: costRatings.bottomAnchor, constant: 10),
            buttonsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sellerView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 10),
            sellerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textView.topAnchor.constraint(equalTo: sellerButton.bottomAnchor),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {
            suggActions in
            let menu = self.makeMenuActions()
            return UIMenu(title: "Add to Shopping List" , children: menu)
            
        })
    }
    
    func makeMenuActions() -> [UIAction] {
        let shoppingLists = ApplicationDB.shared.getShoppingLists()
        var menu = shoppingLists.map({ list in return UIAction(
            title: list.name,
            image: UIImage(systemName: "heart.fill"),
            handler: { _ in
                self.delegate?.addToShoppingList(list: list)
                
            })
        })
        let addAction = UIAction(
            title: "Create Shopping list",
            image: UIImage(systemName: "plus.circle"),
            handler: { _ in
                let alert = UIAlertController(title: "Create Shopping List", message: "Enter name for Shopping List: ", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { textfield in
                    textfield.placeholder = "Enter name"
                })
                let action = UIAlertAction(title: "Create", style: .default, handler: {
                    _ in
                    let textField = alert.textFields![0]
                    if let text = textField.text, text.isEmpty {
                        Toast.shared.showToast(message: "Name cannot be empty!!")
                        return
                    }
                    ApplicationDB.shared.addShoppingList(name: textField.text ?? "Untitled")
                    if let vc = self.parentViewController as? ProductViewController {
                        vc.collectionView.reloadData()
                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                alert.addAction(action)
                alert.addAction(cancelAction)
                self.parentViewController?.present(alert, animated: true, completion: nil)
            }
        )
        menu.append(addAction)
        return menu
    }
    
    @objc
    func onShoppingClick() {
        Toast.shared.showToast(message: "Press and hold to select list")
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
        attr.size = cellFrame
        return attr
    }
   
}

protocol DescriptionCellDelegate {
    func displaySeller(sellerData: Seller)
    func buyClicked()
    func addToCartClicked()
    func addToShoppingList(list: ShoppingList)
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
}
