//
//  SearchItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit
import Combine

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    
    static let cellID = "SearchListItem"
    
    var cancellable: AnyCancellable?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = UIColor.appTextColor
        label.font = .italicSystemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 0"
        label.textColor = UIColor.subtitleTextColor
        label.font = .italicSystemFont(ofSize: 16)
        return label
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.subtitleTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.thumbNailTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 10)
        label.text = "0.0/5.0"
        return label
    }()
    
    var data: Product? {
        willSet {
            if newValue != nil {
                nameLabel.text = newValue!.product_name
                costLabel.text = "$ \(newValue!.price)"
                cancellable = self.loadImage(for: newValue!.image_media[0]).sink(receiveValue: {
                    [unowned self] image in
                    self.imageView.image = image
                })
                ratingLabel.text = "\(newValue!.rating)/5.0"
            }
            self.setupLayout()
        }
    }
    
    
    
    func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(bottomLine)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -5),
            ratingLabel.rightAnchor.constraint(equalTo: bottomLine.rightAnchor, constant: -10),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.8),
            bottomLine.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            bottomLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: url)!
                return ImageLoader.shared.loadImage(from: url)
                
            })
           .eraseToAnyPublisher()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.imageView.image = UIImage(systemName: "photo.fill")
        cancellable?.cancel()
    }
}
