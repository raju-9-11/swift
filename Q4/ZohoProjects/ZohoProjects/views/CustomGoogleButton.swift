//
//  CustomGoogleImage.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class CustomGoogleButton: UIButton {
    
    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "google")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var customTitleLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var imageName: String = "google" {
        willSet {
            self.imageView?.image = UIImage(named: newValue)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(customImageView)
        self.addSubview(customTitleLabel)
        self.setupLayout()
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            customImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            customImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            customTitleLabel.leftAnchor.constraint(equalTo: customImageView.rightAnchor, constant: 5),
            customTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            
        ])
    }
    
    
}
