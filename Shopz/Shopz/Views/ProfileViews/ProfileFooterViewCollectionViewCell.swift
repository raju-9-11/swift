//
//  ProfileFooterViewCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class ProfileFooterViewCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "PrOFIlefootercellid"
    
    var cellFrame: CGRect? {
        willSet {
            self.setupLayout()
        }
    }
    
    let logout: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor(named: "text_color") , for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .medium
            config.baseBackgroundColor = .red.withAlphaComponent(0.5)
            button.configuration = config
        } else {
            button.layer.cornerRadius = 6
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.backgroundColor = .red.withAlphaComponent(0.5)
        }
        return button
    }()
    
    func setupLayout() {
        contentView.addSubview(logout)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        
        logout.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            logout.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logout.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logout.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ])
    }
    
    @objc 
    func onLogout() {
        Auth.auth?.logout()
    }
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame?.width ?? 100, height: 50)
        return attr
    }
    
}

