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
            circleWidthConstraint.constant = newValue
            circleHeightConstraint.constant = newValue
            circleView.layer.cornerRadius = newValue / 2.0
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
    
    
    
}
