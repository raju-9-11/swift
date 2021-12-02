//
//  UsersCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 02/12/21.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    
    let profilePic: ProfileImageView = {
        let imageView = ProfileImageView()
        imageView.image = UIImage(named: "google")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let subContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "name"
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "email"
        return label
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile"
        return label
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile"
        label.textColor = .systemGray
        return label
    }()
    
    var userData: UserDataModel = UserDataModel(name: "TEST", email: "TEST", role: .vendor, profile: .vendor, image: UIImage(named: "google")) {
        willSet {
            nameLabel.text = newValue.name
            emailLabel.text = newValue.email
            profileLabel.text = newValue.profile?.rawValue
            profilePic.image = newValue.image
            roleLabel.text = "Project Profile: \(newValue.role?.rawValue ?? "Unknown")"
        }
    }
    
    func setImage(_ image: UIImage?) {
        profilePic.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleContainer)
        contentView.addSubview(subContainer)

        titleContainer.addSubview(profileLabel)
        subContainer.addSubview(profilePic)
        subContainer.addSubview(nameLabel)
        subContainer.addSubview(emailLabel)
        subContainer.addSubview(roleLabel)
        
        self.layer.cornerRadius = 3
        self.backgroundColor = .white
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            titleContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileLabel.leftAnchor.constraint(equalTo: titleContainer.leftAnchor, constant: 15),
            profileLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            subContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            subContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            subContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profilePic.centerYAnchor.constraint(equalTo: subContainer.centerYAnchor),
            profilePic.heightAnchor.constraint(equalTo: subContainer.heightAnchor, multiplier: 0.5),
            profilePic.widthAnchor.constraint(equalTo: subContainer.heightAnchor, multiplier: 0.5),
            profilePic.leftAnchor.constraint(equalTo: subContainer.leftAnchor, constant: 15),
            emailLabel.centerYAnchor.constraint(equalTo: subContainer.centerYAnchor),
            emailLabel.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 15),
            nameLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 15),
            roleLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            roleLabel.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 15),
        ])
    }
    
}
