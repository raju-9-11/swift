//
//  AddAddressCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class AddAddressCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddAddress"
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .black
        textView.contentMode = .center
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.text = "Add Address"
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addButton, label])
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    
    func setupLayout() {
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1).cgColor
        contentView.layer.cornerRadius = 6
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}
