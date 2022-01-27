//
//  ProfileTopViewCollectioViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ProfileTopViewCollectioViewCell: UICollectionViewCell {
    
    static let cellID: String = "ProfileTopViewCell"
    
    weak var delegate: ProfileImagesViewDelegate?
    
    let profileTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let profilePic: RoundedImage = {
        let imageView = RoundedImage()
        imageView.isRounded = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.isUserInteractionEnabled = true
        imageView.layer.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(UIColor(named: "text_color") , for: .normal)
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
                nameLabel.text = (Auth.auth != nil) ? "\(Auth.auth!.user.firstName) \(Auth.auth!.user.lastName) ": "Unknown"
                self.setupLayout()
                if newValue?.profileImageMedia != nil && newValue?.bgImageMedia != nil {
                    bgImage.image = UIImage(data: (newValue?.bgImageMedia)!)
                    profilePic.image = UIImage(data: (newValue?.profileImageMedia)!)
                }
            }
        }
    }
    
    var cellFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    func setupLayout() {
        profilePic.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongProfilePress)))
        contentView.addSubview(bgImage)
        contentView.addSubview(profilePic)
        contentView.addSubview(editProfileButton)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        bgImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBgClick)))
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileClick)))
        editProfileButton.addTarget(self, action: #selector(onEdit), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2),
            bgImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bgImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            bgImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profilePic.centerYAnchor.constraint(equalTo: bgImage.bottomAnchor),
            profilePic.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            profilePic.heightAnchor.constraint(equalToConstant: 50),
            profilePic.widthAnchor.constraint(equalToConstant: 50),
            editProfileButton.topAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: 5),
            editProfileButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 5),
            nameLabel.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor)
        ])
    }
    
    @objc
    func onLongProfilePress() {
        delegate?.pickProfilePic()
    }
    
    @objc
    func onBgClick() {
        delegate?.displayImage(bgImage.image)
    }
    
    @objc
    func onProfileClick() {
        delegate?.displayImage(profilePic.image)
    }
    
    @objc
    func onEdit() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        profilePic.image = UIImage(systemName: "person.circle.fill")
        bgImage.image = UIImage(systemName: "image.fill")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = CGSize(width: cellFrame.width, height: 200)
        return attr
    }
    
    
}

protocol ProfileImagesViewDelegate: AnyObject {
    func displayImage(_ image: UIImage?)
    func pickProfilePic()
}

