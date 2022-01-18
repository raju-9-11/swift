//
//  ProfileTopViewCollectioViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ProfileTopViewCollectioViewCell: UICollectionViewCell {
    
    static let cellID: String = "ProfileTopViewCell"
    
    let profileTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let profilePic: RoundedImage = {
        let imageView = RoundedImage()
        imageView.isRounded = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.black , for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .medium
            config.baseBackgroundColor = UIColor(red: 0.917, green: 0.881, blue: 0.561, alpha: 1)
            button.configuration = config
        } else {
            button.layer.cornerRadius = 6
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.backgroundColor = UIColor(red: 0.917, green: 0.881, blue: 0.561, alpha: 1)
        }
        return button
    }()
    
    var profileData: ProfileData? {
        willSet {
            if newValue != nil {
                self.setupLayout()
                self.nameLabel.text = newValue?.name
            }
        }
    }
    
    var cellFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    func setupLayout() {
        profileTopView.addSubview(bgImage)
        profileTopView.addSubview(profilePic)
        profileTopView.addSubview(editProfileButton)
        profileTopView.addSubview(nameLabel)
        editProfileButton.addTarget(self, action: #selector(onEdit), for: .touchUpInside)
        contentView.addSubview(profileTopView)
        
        NSLayoutConstraint.activate([
            profileTopView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            profileTopView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            profileTopView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileTopView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bgImage.topAnchor.constraint(equalTo: profileTopView.topAnchor, constant: -2),
            bgImage.widthAnchor.constraint(equalTo: profileTopView.widthAnchor),
            bgImage.heightAnchor.constraint(equalTo: profileTopView.heightAnchor, multiplier: 0.6),
            bgImage.centerXAnchor.constraint(equalTo: profileTopView.centerXAnchor),
            profilePic.centerYAnchor.constraint(equalTo: bgImage.bottomAnchor),
            profilePic.leftAnchor.constraint(equalTo: profileTopView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            profilePic.heightAnchor.constraint(equalToConstant: 50),
            profilePic.widthAnchor.constraint(equalToConstant: 50),
            editProfileButton.topAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: 5),
            editProfileButton.rightAnchor.constraint(equalTo: profileTopView.rightAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor)
        ])
    }
    
    @objc
    func onEdit() {
        Auth.auth?.logout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame.width - 2, height: 200)
        return attr
    }
    
    
}

