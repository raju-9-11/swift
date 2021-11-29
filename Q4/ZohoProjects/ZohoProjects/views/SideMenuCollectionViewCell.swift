//
//  SideMenuCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit


class SideMenuCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        willSet {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
                self.contentView.backgroundColor = newValue ? .systemGray3 : .clear
                self.nameLabel.textColor = newValue ? .white : .black
            }, completion: nil)
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var itemString: MenuItem = MenuItem(name: "Placeholder", icon: "sidebar.leading") {
        willSet {
            self.icon.image = UIImage(systemName: newValue.icon)?.withRenderingMode(.alwaysTemplate)
            self.nameLabel.text = newValue.name
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(icon)
        self.setupLayout()
        
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            icon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.98),
            icon.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.98),
            nameLabel.leftAnchor.constraint(equalTo: icon.safeAreaLayoutGuide.rightAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
}
