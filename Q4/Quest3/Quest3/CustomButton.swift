//
//  CustomButton.swift
//  Quest3
//
//  Created by Rajkumar S on 09/11/21.
//

import UIKit

class CustomButton: UIButton {
    
    var container1 = Container()
    var container2 = Container()
    
    var data: (text: String, color: UIColor) = (text: "Label", color: .red) {
        willSet {
            container1.imageView.backgroundColor = newValue.color
            container1.label.text = newValue.text
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        
        container1.imageView.image = UIImage(systemName: "multiply.circle.fill")
        container2.imageView.image = UIImage(systemName: "circle")
        
        self.addSubview(container1.label)
        self.addSubview(container2.label)
        self.addSubview(container1.imageView)
        self.addSubview(container2.imageView)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            container1.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),
            container1.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            container1.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            container1.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            container1.label.centerXAnchor.constraint(equalTo: container1.imageView.centerXAnchor),
            container1.label.bottomAnchor.constraint(equalTo: container1.imageView.safeAreaLayoutGuide.topAnchor, constant: -10),
            container2.imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45),
            container2.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
            container2.imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            container2.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            container2.label.centerXAnchor.constraint(equalTo: container2.imageView.centerXAnchor),
            container2.label.bottomAnchor.constraint(equalTo: container2.imageView.safeAreaLayoutGuide.topAnchor, constant: -10),
        ])
    }

}

class Container {
    var imageView: UIImageView!
    var label: UILabel!
    
    init() {
        initializeContainer()
    }
    
    func initializeContainer() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Label"
    }
}
