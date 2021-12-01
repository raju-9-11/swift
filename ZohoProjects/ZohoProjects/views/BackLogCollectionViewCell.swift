//
//  BackLogCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit

class BackLogCollectionViewCell: UICollectionViewCell {
    
    var size: CGSize = .zero
    
    var priorityCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var data: BacklogDataModel = BacklogDataModel(title: "Title", description: "Descrtiption") {
        willSet {
            priorityCircle.backgroundColor = newValue.priority == .none ? .darkGray : newValue.priority == .low ? .systemGreen : newValue.priority == .medium ? .systemOrange : .systemRed
            titleLabel.text = newValue.title
            subTitleLabel.text = "L1 - I\(newValue.index) • \(newValue.type.rawValue)"
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                self.contentView.backgroundColor = newValue ? .systemGray2 : .white
                self.titleLabel.textColor = newValue ? .white : .black
                self.subTitleLabel.textColor = newValue ? .white : .systemGray2
            }, completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(priorityCircle)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        self.backgroundColor = .white
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.setupLayout()
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            priorityCircle.widthAnchor.constraint(equalToConstant: 8),
            priorityCircle.heightAnchor.constraint(equalToConstant: 8),
            priorityCircle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            priorityCircle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: priorityCircle.rightAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subTitleLabel.leftAnchor.constraint(equalTo: priorityCircle.rightAnchor, constant: 10),
        ])
        priorityCircle.layer.cornerRadius = 4
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size.width = size.width - 15
        attr.size.height = 60
        return attr
    }
    
}
