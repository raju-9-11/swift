//
//  BoardCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 01/12/21.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "String"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var outerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 7
        return view
    }()
    
    var topIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "square.stack")
        imageView.tintColor = .black
        return imageView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "String"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var boardType: BoardType = BoardType(name: "To do", count: 0, color: .systemPink) {
        willSet {
            outerContainer.backgroundColor = newValue.color
            titleLabel.text = newValue.name
            countLabel.text = "\(newValue.count)"
        }
    }
    
    let topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topContainer.addSubview(titleLabel)
        topContainer.addSubview(topIcon)
        topContainer.addSubview(countLabel)
        outerContainer.addSubview(topContainer)
        contentView.addSubview(outerContainer)
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            outerContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            outerContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            outerContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            outerContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95),
            topContainer.topAnchor.constraint(equalTo: outerContainer.topAnchor),
            topContainer.widthAnchor.constraint(equalTo: outerContainer.widthAnchor),
            topContainer.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor),
            topContainer.heightAnchor.constraint(equalTo: outerContainer.heightAnchor, multiplier: 0.1),
            titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 15),
            countLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            countLabel.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -15),
            topIcon.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 10),
            topIcon.rightAnchor.constraint(equalTo: countLabel.leftAnchor, constant: -5),
        ])
    }
    
    
}
