//
//  AddAddressCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class AddAddressCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddAddress"
    
    var delegate: AddAddressCellDelegate?
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func setupLayout() {
        contentView.backgroundColor = .blue
        contentView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    @objc
    func addClicked() {
        self.delegate?.onAddClick()
    }
    
}

protocol AddAddressCellDelegate {
    func onAddClick()
}
