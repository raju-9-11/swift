//
//  SearchbarTableViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 26/01/22.
//

import UIKit

class SearchbarTableViewCell: UITableViewCell {
    
    var text: String = "" {
        willSet {
            label.text = newValue
            self.setupLayout()
        }
    }
    
    var font: UIFont {
        get {
            return label.font
        }
        set {
            label.font = newValue
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.appTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    static let cellID: String = "SearchBarItemCellID"
    
    func setupLayout() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 5),
            label.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.text = ""
    }

}
