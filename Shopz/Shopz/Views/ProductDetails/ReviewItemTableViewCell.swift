//
//  ReviewItemTableViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewItemTableViewCell: UITableViewCell {
    
    static let cellID = "ReviewITemCELL"
    
    var review: Review = Review(review: "", owner: "") {
        willSet {
            self.setupLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach({ view in view.removeFromSuperview() })
    }

}
