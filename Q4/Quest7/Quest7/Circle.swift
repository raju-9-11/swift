//
//  Circle.swift
//  Quest7
//
//  Created by Rajkumar S on 29/10/21.
//

import Foundation
import UIKit


class Circle {
    var circleView: UIButton!
    
    var circleWidthConstraint: NSLayoutConstraint! 
    var circleHeightConstraint: NSLayoutConstraint!
    var radius: CGFloat! {
        willSet {
            self.circleWidthConstraint.constant = newValue
            self.circleHeightConstraint.constant = newValue
            self.circleView.layer.cornerRadius = newValue / 2.0
        }
    }
    
    
    init(circleView: UIButton, radius: CGFloat) {
        self.circleView = circleView
        self.radius = radius
        self.circleWidthConstraint = circleView.widthAnchor.constraint(equalToConstant: radius)
        self.circleHeightConstraint = circleView.heightAnchor.constraint(equalToConstant: radius)
        self.circleWidthConstraint.isActive = true
        self.circleHeightConstraint.isActive = true
        self.circleView.layer.cornerRadius = radius / 2.0
    }
    
    func dropShadow() {
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.circleView.layer.masksToBounds = true
        self.circleView.layer.shadowRadius = 3.0
        self.circleView.layer.shadowOpacity = 1.0
    }
    
    func removeShadow() {
        self.circleView.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    }
    
    
    
}
