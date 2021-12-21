//
//  AddressItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class AddressItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddressItemCell"
    
    var address: String = "" {
        willSet {
            addressTextView.text = newValue
            contentView.backgroundColor = .blue
            self.setupLayout()
        }
    }
    
    override open var isSelected: Bool {
        willSet {
            print("Selected")
        }
    }
    
    let addressTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func setupLayout() {
        contentView.addSubview(addressTextView)
        NSLayoutConstraint.activate([
            addressTextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            addressTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            addressTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addressTextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}
