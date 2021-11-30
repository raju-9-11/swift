//
//  DropDownCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 30/11/21.
//

import UIKit

class DropDownCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        willSet {
            titleLabel.textColor = newValue ? .white : isCustomSelected ? .green : .black
            self.contentView.backgroundColor = newValue ? .gray : isCustomSelected ? .systemGray4 : .clear
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "String"
        return label
    }()
    
    var isCustomSelected: Bool = false {
        willSet {
            titleLabel.textColor = newValue ? .green : .black
            self.contentView.backgroundColor = newValue ? .systemGray4 : .clear
        }
    }
    
    var sprint: SprintsDataModel = SprintsDataModel(name: "Pacman", description: "Description") {
        willSet {
            titleLabel.text = newValue.name
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        self.setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
        ])
    }
    
}
