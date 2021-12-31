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
            self.setupLayout()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.seal.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tintColor = .white
        return imageView
    }()
    
    var isCustSelected: Bool = false {
        willSet {
            contentView.backgroundColor = newValue ? UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1) : .white
            addressTextView.textColor = newValue ? .white : .black
            imageView.isHidden = !newValue
        }
    }
    
    let addressTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .black
        textView.contentMode = .center
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.font = .systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        return textView
    }()
    
    func setupLayout() {
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1).cgColor
        contentView.layer.cornerRadius = 6
        contentView.addSubview(addressTextView)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            imageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            addressTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            addressTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            addressTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addressTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}
