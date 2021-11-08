//
//  Container.swift
//  Quest6
//
//  Created by Rajkumar S on 05/11/21.
//

import Foundation
import UIKit

class Container {
    
    var containerView: UIView!
    var label: UILabel!
    
    
    init() {
        self.newContainer()
    }
    
    
    func newContainer() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel()
        label.font = .boldSystemFont(ofSize: 11)
        label.text = "PlaceHolder"
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
    }
    
}
