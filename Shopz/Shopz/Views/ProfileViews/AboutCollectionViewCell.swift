//
//  AboutCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class AboutCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AboutCell"
    
    var cellFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var aboutView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 6
        textView.font = .systemFont(ofSize: 12, weight: .regular)
        textView.textColor = .darkGray
        textView.text = aboutData.about
        textView.textAlignment = .center
        textView.isEditable = false
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    var aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var aboutData: AboutData = AboutData(about: "Write about...") {
        willSet {
            if newValue.about != "" {
                aboutView.text = newValue.about
            } else {
                aboutView.text = "Write about...."
            }
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        containerView.addSubview(aboutLabel)
        containerView.addSubview(aboutView)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aboutView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.7),
            aboutView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9),
            aboutView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            aboutView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 5),
            aboutLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            aboutLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame.width - 2, height: 130)
        return attr
    }
    
    
}
