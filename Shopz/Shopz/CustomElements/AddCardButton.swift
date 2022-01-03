//
//  AddCardButton.swift
//  Shopz
//
//  Created by Rajkumar S on 03/01/22.
//

import UIKit

class AddCardButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let customTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        customTitle.text = title
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        customTitle.textColor = color
        addImageView.tintColor = color
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.removeFromSuperview()
        self.imageView?.removeFromSuperview()
        self.addSubview(addImageView)
        self.addSubview(customTitle)
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.baseBackgroundColor = UIColor(red: 0.489, green: 0.794, blue: 0.965, alpha: 1)
            config.cornerStyle = .medium
            self.configuration = config
        } else {
            self.backgroundColor = UIColor(red: 0.489, green: 0.794, blue: 0.965, alpha: 1)
            self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            self.layer.cornerRadius = 6
        }
        
        NSLayoutConstraint.activate([
            customTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            customTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addImageView.leftAnchor.constraint(equalTo: customTitle.rightAnchor, constant: 5),
            addImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            addImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
        ])
        
    }
    
    override var isHighlighted: Bool {
        willSet {
            self.addImageView.tintColor = newValue ? .red : .white
            self.customTitle.textColor = newValue ? .red : .white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 15, *) {
            self.configuration?.contentInsets.trailing = addImageView.frame.width + 10
        } else {
            self.contentEdgeInsets.right = addImageView.frame.width + 10
        }
    }
}
