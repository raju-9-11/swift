//
//  ViewController.swift
//  Quest7
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var circles: [UIView] = []
    var radius = 30.0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        //Setup stackView
        

        //Setup circles
        let circle_1 = newCircle(radius)
        let circle_2 = newCircle(radius)
        let circle_3 = newCircle(radius)
        let circle_4 = newCircle(radius)
        let circle_5 = newCircle(radius)
        let circle_6 = newCircle(radius)
        let circle_7 = newCircle(radius)
        let circle_8 = newCircle(radius)
        let circle_9 = newCircle(radius)
        circles = [circle_1, circle_2, circle_3, circle_4, circle_5, circle_6, circle_7, circle_8, circle_9 ]
        
        let top = newStackView([circle_1, circle_2, circle_3])
        let middle = newStackView([circle_4, circle_5, circle_6])
        let bottom = newStackView([circle_7, circle_8, circle_9])
        
        let outerContainer = UIStackView(arrangedSubviews: [top, middle, bottom])
        outerContainer.axis = .vertical
        outerContainer.alignment = .center
        outerContainer.spacing = 10
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        outerContainer.distribution = .fillEqually
        view.addSubview(outerContainer)
        
        NSLayoutConstraint.activate([
            outerContainer.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            outerContainer.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            outerContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            outerContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            top.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
            middle.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
            bottom.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
        ])
        
    }
    
    
    func newStackView(_ elements: [UIView]) -> UIStackView {
        let myStackView = UIStackView(arrangedSubviews: elements)
        myStackView.axis = .horizontal
        myStackView.alignment = .center
        myStackView.distribution = .equalCentering
        myStackView.spacing = 10
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        return myStackView
    }
    
    
    func newCircle(_ rad: CGFloat) -> UIView {
        
        let circle = UIView()
        circle.backgroundColor = .red
        circle.layer.cornerRadius = rad
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.orange.cgColor
        circle.layer.borderWidth = 3.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(circleTapped))
        circle.addGestureRecognizer(tap)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: rad*2).isActive = true
        circle.heightAnchor.constraint(equalToConstant: rad*2).isActive = true

        return circle
    }
    
    @objc
    func circleTapped() {
        print(" Circle Tapped")
        radius += 1
//        circles.map{ circle in
//            circle.frame.size.width = radius
//            circle.frame.size.height = radius
//            circle.widthAnchor.constraint(equalToConstant: radius*2).isActive = true
//            circle.heightAnchor.constraint(equalToConstant: radius*2).isActive = true
//            circle.layer.cornerRadius = radius
//        }
    }
}


