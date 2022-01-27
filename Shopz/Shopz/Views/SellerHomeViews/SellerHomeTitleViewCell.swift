//
//  SellerHomeTitleCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class SellerHomeTitleViewCell: UITableViewCell {
    
    static let cellID = "SELLERHOMEtitlecellid"
    
    var title: String = "" {
        willSet {
            titleLabel.text = newValue
            self.setupLayout()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.font = .monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 2
        label.contentMode = .center
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}


extension UITableViewCell {
    func removeViews() {
        self.contentView.subviews.forEach({ view in view.removeFromSuperview() })
    }
}
