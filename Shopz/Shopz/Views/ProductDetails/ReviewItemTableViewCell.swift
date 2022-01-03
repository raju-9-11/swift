//
//  ReviewItemTableViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewItemTableViewCell: UITableViewCell {
    
    static let cellID = "ReviewITemCELL"
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profilePic: RoundedImage = {
        let imageView = RoundedImage()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let reviewView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = .gray
        textview.isEditable = false
        textview.isSelectable = false
        textview.isUserInteractionEnabled = false
        textview.backgroundColor = .clear
        return textview
    }()
    
    var review: Review = Review(review: "", owner: "") {
        willSet {
            reviewView.text = newValue.review
            nameLabel.text = newValue.owner
            self.setupLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        contentView.addSubview(profilePic)
        containerView.addSubview(nameLabel)
        containerView.addSubview(reviewView)
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            containerView.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 10),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePic.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profilePic.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            profilePic.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            reviewView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reviewView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach({ view in view.removeFromSuperview() })
    }

}
