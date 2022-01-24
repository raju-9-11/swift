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
//        view.backgroundColor = .white
        return view
    }()
    
    let aboutView: TextViewWithPlaceHolder = {
        let textView = TextViewWithPlaceHolder()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 6
        textView.font = .systemFont(ofSize: 13, weight: .regular)
        textView.textColor = .darkGray
        textView.text = ""
        textView.placeholder = "Write about placeholder"
        textView.textAlignment = .center
        textView.isEditable = false
        textView.backgroundColor = .clear
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
    
    var aboutData: AboutData = AboutData() {
        willSet {
            aboutView.text = Auth.auth?.user.about ?? ""
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        contentView.addSubview(aboutLabel)
        contentView.addSubview(aboutView)
        aboutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
//            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
//            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aboutView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            aboutView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            aboutView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aboutView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 5),
            aboutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            aboutLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
        ])
    }
    
    @objc
    func onClick() {
        print("Editing about...")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame.width, height: 130)
        return attr
    }
    
    
}
