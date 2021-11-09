//
//  ViewController.swift
//  Quest7
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var circles: [Circle] = []
    let radius = 50.0
    var outerContainer: UIStackView!
    var topView: UIStackView!
    var midView: UIStackView!
    var bottomView: UIStackView!
    var colors:[UIColor] = [.red, .black, .blue, .brown, .green, .yellow, .cyan, .darkGray, .orange]
    var bezierPathTop: ZigzagView!
    var bezierPathBottom: ZigzagView!
    var pathOuterContainer: UIStackView!
    var testViewTop: UIView!
    var testViewBottom: UIView!
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.frame = UIScreen.main.bounds
        
        
        //Create Circles
        for index in 1...9 {
            circles.append(Circle(circleView: newCircle(radius, circleIndex: index, color: generateColor()), radius: radius))
        }
        
        // Create stacks
        topView = newStackView([circles[0].circleView, circles[1].circleView, circles[2].circleView])
        midView = newStackView([circles[3].circleView, circles[4].circleView, circles[5].circleView])
        bottomView = newStackView([circles[6].circleView, circles[7].circleView, circles[8].circleView])
        
        //Zigzag line
        bezierPathTop = ZigzagView()
        bezierPathTop.draw(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.bezierPathTop.frame.height))
        bezierPathTop.translatesAutoresizingMaskIntoConstraints = false

        bezierPathBottom = ZigzagView()
        bezierPathBottom.draw(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.bezierPathTop.frame.height))
        bezierPathBottom.translatesAutoresizingMaskIntoConstraints = false
        
        //Parent Container for bezier Path
        pathOuterContainer = newStackView([bezierPathTop, bezierPathBottom], alignment: .center, spacing: 0, distribution: .fillEqually, axis: .vertical)
        view.addSubview(pathOuterContainer)
        
        // Create parent container for views
        outerContainer = newStackView([topView, midView, bottomView], alignment: .center, spacing: 10, distribution: .fillEqually, axis: .vertical)
        view.addSubview(outerContainer)
        
        // Setup Layout Constraints
        setupConstraints()
        
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Code
    }
    
    
    
    
    func newStackView(_ elements: [UIView], alignment: UIStackView.Alignment = .center, spacing: CGFloat = 10, distribution: UIStackView.Distribution = .equalCentering, axis: NSLayoutConstraint.Axis = .horizontal ) -> UIStackView {
        let myStackView = UIStackView(arrangedSubviews: elements)
        myStackView.axis = axis
        myStackView.alignment = alignment
        myStackView.distribution = distribution
        myStackView.spacing = spacing
        myStackView.isLayoutMarginsRelativeArrangement = true
        myStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        return myStackView
    }
    
    
    func newCircle(_ rad: CGFloat, circleIndex: Int, color: UIColor) -> UIButton {
        
        let circle = UIButton(type: .roundedRect)
        circle.backgroundColor = color
        circle.layer.masksToBounds = true
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
            pathOuterContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            pathOuterContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pathOuterContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pathOuterContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            bezierPathTop.widthAnchor.constraint(equalTo: pathOuterContainer.safeAreaLayoutGuide.widthAnchor, constant: -20),
            bezierPathBottom.widthAnchor.constraint(equalTo: pathOuterContainer.safeAreaLayoutGuide.widthAnchor, constant: -20),
        ])
        
    }
    
    func generateColor() -> UIColor {
        let num = Int.random(in: 0..<colors.count)
        let color = colors.remove(at: num)
        
        return color
    }
    
    @objc
    func circleTapped(sender: UIButton) {
        guard let circleNumber = Int(sender.title(for: .normal)!) else { return }
        sender.removeTarget(self, action: #selector(circleTapped(sender:)), for: .touchUpInside)
        let circle = circles[circleNumber % 9]
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            circle.radius += 20
            circle.dropShadow()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
            circle.radius -= 20
            circle.removeShadow()
            self.view.layoutIfNeeded()
        }, completion: {
             finished in
            sender.addTarget(self, action: #selector(self.circleTapped(sender:)), for: .touchUpInside)
        })
        
    }
    

}
