//
//  ViewController.swift
//  Quest7
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var circles: [Circle] = []
    var radius = 30.0
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        //Setup stackView
        
        
        for index in 1...9 {
            circles.append(Circle(circleView: newCircle(radius, circleIndex: index), radius: radius))
        }
        
        let top = newStackView([circles[0].circleView, circles[1].circleView, circles[2].circleView])
        let middle = newStackView([circles[3].circleView, circles[4].circleView, circles[5].circleView])
        let bottom = newStackView([circles[6].circleView, circles[7].circleView, circles[8].circleView])
        
        
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
        myStackView.isLayoutMarginsRelativeArrangement = true
        myStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        return myStackView
    }
    
    
    func newCircle(_ rad: CGFloat, circleIndex: Int) -> UIButton {
        
        let circle = UIButton()
        circle.backgroundColor = .red
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.orange.cgColor
        circle.layer.borderWidth = 3.0
        circle.setTitle("\(circleIndex)", for: .normal)
        circle.addTarget(self, action: #selector(circleTapped(sender:)), for: .touchUpInside)

        return circle
    }
    
    @objc
    func circleTapped(sender: UIButton) {
        guard let circleNumber = Int(sender.title(for: .normal)!) else { return }
        print(" Circle Tapped \(circleNumber)")
        circles[circleNumber - 1].radius += 1
    }
}



