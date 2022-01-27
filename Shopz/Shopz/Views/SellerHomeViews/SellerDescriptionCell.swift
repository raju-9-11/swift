//
//  SellerDescriptionCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class SellerDescriptionCell: UITableViewCell {

    static let cellID = "SELLERHOMEDescriptioncellid"
    
    var sellerDescription: String = "" {
        willSet {
            descriptionView.text = newValue
            self.setupLayout()
        }
    }
    
    let descriptionView: TextViewWithPlaceHolder = {
        let label = TextViewWithPlaceHolder()
        label.textViewTextColor = UIColor(named: "text_color")
        label.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.isEditable = false
        label.isSelectable = false
        label.removeBorder()
        label.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        contentView.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            descriptionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            descriptionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }

}
