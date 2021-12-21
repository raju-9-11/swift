//
//  CardItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class CardItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CardItemCELL"
    
    var cardData: CardData = CardData(name: "", number: "", validityDate: Date()) {
        willSet {
            dateLabel.text = newValue.getDateInFormat()
            nameLabel.text = newValue.name
            numberLabel.text = newValue.number
            self.setupLayout()
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = .red.withAlphaComponent(0.5)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(numberLabel)
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            numberLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: numberLabel.topAnchor, constant: -5),
            dateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
}

class CardData {
    var name: String
    var number: String
    var validityDate: Date
    
    init(name: String, number: String, validityDate: Date) {
        self.name = name
        self.number = number
        self.validityDate = validityDate
    }
    
    func getDateInFormat() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/YYY"
        return dateformatter.string(from: self.validityDate)
    }
}
