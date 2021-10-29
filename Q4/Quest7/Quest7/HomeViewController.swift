//
//  ViewController.swift
//  Quest7
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var circles: [Circle] = []
    var radius = 40.0
    var outerContainer: UIStackView!
    var topView: UIStackView!
    var midView: UIStackView!
    var bottomView: UIStackView!
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        //Create Circles
        for index in 1...9 {
            circles.append(Circle(circleView: newCircle(radius, circleIndex: index), radius: radius))
        }
        
        // Create stacks
        topView = newStackView([circles[0].circleView, circles[1].circleView, circles[2].circleView])
        midView = newStackView([circles[3].circleView, circles[4].circleView, circles[5].circleView])
        bottomView = newStackView([circles[6].circleView, circles[7].circleView, circles[8].circleView])
        
        // Create parent container for views
        outerContainer = UIStackView(arrangedSubviews: [topView, midView, bottomView])
        outerContainer.axis = .vertical
        outerContainer.alignment = .center
        outerContainer.spacing = 10
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        outerContainer.distribution = .fillEqually
        view.addSubview(outerContainer)
        
        // Setup Constraints
        setupConstraints()
        
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
        circle.setTitleColor(.init(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        circle.setTitle("\(circleIndex)", for: .normal)
        circle.addTarget(self, action: #selector(circleTapped(sender:)), for: .touchUpInside)

        return circle
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            outerContainer.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            outerContainer.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            outerContainer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            outerContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            topView.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
            midView.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
            bottomView.widthAnchor.constraint(equalTo: outerContainer.layoutMarginsGuide.widthAnchor),
        ])
    }
    
    @objc
    func circleTapped(sender: UIButton) {
        guard let circleNumber = Int(sender.title(for: .normal)!) else { return }
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.circles[circleNumber % 9].radius += 15
            self.view.layoutIfNeeded()
        }, completion: {
            _ in
            /// PLACEHOLDER
        })
        
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
            self.circles[circleNumber % 9].radius -= 15
            self.view.layoutIfNeeded()
        }, completion: {
            _ in
            /// PLACEHOLDER
        })

        
    }
    
}



