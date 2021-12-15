//
//  FormDatePickerCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import UIKit

class FormDatePickerCollectionViewCell: UICollectionViewCell {
    
}


extension UICollectionViewCell {
    
    func removeViews() {
        self.contentView.subviews.forEach({ view in view.removeFromSuperview() })
    }
}
