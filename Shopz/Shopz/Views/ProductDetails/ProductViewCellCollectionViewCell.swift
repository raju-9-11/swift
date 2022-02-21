//
//  ProductViewCellCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit
import Combine

class ProductViewCellCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ProductImageView"
    var cancellable: AnyCancellable?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.shopzBackGroundColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var data: String? {
        willSet {
            if newValue != nil {
                cancellable = self.loadImage(for: newValue!).sink(receiveValue: {
                    [unowned self] image in
                    imageView.image = image
                })
            }
            self.setupLayout()
        }
    }
    
    func setupLayout() {
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
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
        cancellable?.cancel()
    }
    
}
