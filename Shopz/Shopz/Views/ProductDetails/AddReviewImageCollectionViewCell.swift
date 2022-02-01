//
//  AddImageCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 01/02/22.
//

import UIKit

class AddReviewImageCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddReviewImagecollectcellid"
    
    weak var delegate: AddReviewImageDelegate?
    
    var isEnabled: Bool = true {
        willSet {
            closeButton.isHidden = !newValue
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.fill")
        return imageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.setContentMode(mode: .scaleAspectFit)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var image: UIImage? {
        willSet {
            imageView.image = newValue
            self.setupLayout()
        }
    }
    
    var indexPath: IndexPath!
    
    func setupLayout() {
        
        
        closeButton.addTarget(self, action: #selector(onDeleteClick), for: .touchUpInside)
        contentView.addSubview(imageView)
        contentView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            closeButton.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            
            
        ])
    }
    
    @objc
    func onDeleteClick() {
        delegate?.deleteImage(at: indexPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        imageView.image = UIImage(systemName: "photo.fill")
    }
    
}

protocol AddReviewImageDelegate: AnyObject {
    func deleteImage(at index: IndexPath)
}
