//
//  ReportsCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 02/12/21.
//

import UIKit

class ReportsCollectionViewCell: UICollectionViewCell {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        
        
        self.backgroundColor = .white
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.setupLayout()
    }
    
    func setupLayout() {
        
    }
}
