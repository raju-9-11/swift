//
//  CategoryThumbnailCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 11/01/22.
//

import UIKit
import Combine

class CategoryThumbnailCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CategoryItemThumCell"
    
    var cancellable: AnyCancellable?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(systemName: "photo.fill")
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = UIColor(named: "thumbnail_text_color")
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.text = "Text"
        return label
    }()
    
    var data: Category? {
        willSet {
            if newValue != nil {
                self.cancellable = self.loadImage(for: newValue!.media).sink(receiveValue: {
                    [unowned self] image in
                    self.imageView.image = image
                })
                self.label.text = newValue!.name
            }
            self.setupLayout()
        }
    }

    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        contentView.layer.cornerRadius = 6
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 1
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        cancellable?.cancel()
    }
    
    func loadImage(for url: String) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
            .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
                let url = URL(string: url)!
                return ImageLoader.shared.loadImage(from: url)
                
            })
           .eraseToAnyPublisher()
    }
}
