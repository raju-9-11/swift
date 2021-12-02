//
//  DragDropCollectionViewCell.swift
//  DragAndDropInCollectionView
//
//  Created by Payal Gupta on 08/11/17.
//  Copyright © 2017 Payal Gupta. All rights reserved.
//

import UIKit

class DragDropCollectionViewCell: UICollectionViewCell
{
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let customLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Placeholder"
        label.backgroundColor = .init(white: 0, alpha: 0.5)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(customImageView)
        contentView.addSubview(customLabel)
        NSLayoutConstraint.activate([
            customImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            customImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            customImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            customLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
        ])
    }
}
