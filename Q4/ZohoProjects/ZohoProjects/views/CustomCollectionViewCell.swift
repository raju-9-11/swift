//
//  CustomCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "google")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .semibold)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = .systemGray2
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        return textView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textView)
        contentView.addSubview(imageView)
        self.setupLayout()
        
        
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
        ])
    }
    
}
