//
//  GiftCardCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 09/02/22.
//

import UIKit

class GiftCardCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "GiftcardCardItemCELL"
    
    var selectState: Bool = false {
        willSet {
            containerView.backgroundColor = newValue ? .black.withAlphaComponent(0.5) : .systemBlue
            imageView.image = newValue ? UIImage(systemName: "creditcard.fill") : UIImage(systemName: "circle.fill")
            imageView.tintColor = newValue ? .white : .systemYellow
        }
    }
    
    var cardData: GiftCardData? {
        willSet {
            guard let newValue = newValue else { self.setupLayout() ; return }
            dateLabel.text = "Valid until: \(newValue.validityDate.toString(with: "MM/yy"))"
            costLabel.text = "Amount: $ \(newValue.amount)"
            self.setupLayout()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .systemBlue
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        return defaultLabel("")
    }()
    
    lazy var costLabel: UILabel = {
        return defaultLabel("")
    }()
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(costLabel)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            imageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            imageView.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2),
            costLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            costLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectState = false
        self.removeViews()
    }
    
    func defaultLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .white
        return label
    }
}
