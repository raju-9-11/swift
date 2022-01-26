//
//  OrderHistoryItemCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit
import Combine

class OrderHistoryItemCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "OrderHistoryItemCell"
    
    var delegate: OrderHistoryItemDelegate?
    var cancellable: AnyCancellable?
    
    var itemData: OrderHistItem? {
        willSet {
            if newValue != nil {
                nameLabel.text = newValue?.product.product_name
                costLabel.text = "$ \(newValue?.product.price ?? 0) "
                if newValue!.date.offset(from: Date(), by: 6) {
                    buttonsView.addArrangedSubview(returnProduct)
                }
                self.cancellable = self.loadImage(for: newValue!.product.image_media[0]).sink(receiveValue: {
                    [unowned self] image in
                    self.imageView.image = image
                })
                self.dateLabel.text = "Purchase Date: \(newValue!.date.toString())"
                self.setupLayout()
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Item name"
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$ 20"
        label.textColor = UIColor(named: "subtitle_text")
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "24/01/2020"
        label.font = .italicSystemFont(ofSize: 12)
        label.textColor = UIColor(named: "subtitle_text")
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let addReview: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Review", for: .normal)
        button.tintColor = .systemRed
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 6
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(red: 0.933, green: 0.502, blue: 0.502, alpha: 1)
        return button
    }()
    
    let returnProduct: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Return Product", for: .normal)
        button.layer.cornerRadius = 6
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.backgroundColor = .systemRed
        return button
    }()
    
    
    lazy var buttonsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addReview])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        stackView.contentMode = .scaleAspectFit
        return stackView
    }()


    
    func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
        contentView.addSubview(buttonsView)
        contentView.addSubview(dateLabel)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        addReview.addTarget(self, action: #selector(onAddReview), for: .touchUpInside)
        returnProduct.addTarget(self, action: #selector(onReturn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            costLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            dateLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            buttonsView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
//            buttonsView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
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
    
    @objc
    func onAddReview() {
        guard let itemData = self.itemData else { return }
        delegate?.addReview(item: itemData.product)
    }
    
    @objc
    func onReturn() {
        guard let itemData = self.itemData else { return }
        delegate?.returnProduct(item: itemData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        cancellable?.cancel()
    }
    
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date, by dayCount: Int) -> Bool {
        if years(from: date)   > 0 || months(from: date)  > 0{
            return false
        } else {
            if days(from: date) > dayCount {
                return false
            }
        }
        return true
    }
    func toString(with format: String = "dd/MM/yyyy") -> String {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = format
        return df.string(from: self)
    }
}

protocol OrderHistoryItemDelegate {
    func addReview(item: Product)
    func returnProduct(item: OrderHistItem)
}
