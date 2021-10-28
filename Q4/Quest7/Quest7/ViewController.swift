//
//  ViewController.swift
//  Quest7
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    var layer1: [UIView] = []
    var layer2: [UIView] = []
    var layer3: [UIView] = []

    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        var myElements: [UIView] = []
        var myInnerElements: [UIView] = []
        
        for i in 1...9 {
            let element = UIView()
            let innerElement = getCircleView()
            innerElement.frame.size.height = 50
            innerElement.frame.size.width = 50
            innerElement.layer.cornerRadius = innerElement.frame.size.width / 2
            element.addSubview(innerElement)
//            element.backgroundColor = i%2 !=0 ? .green : .gray
            myElements.append(element)
            myInnerElements.append(innerElement)
        }
        
        let testContainer1 = newContainer(elements: [myElements[0], myElements[1], myElements[2]], spacing: 2, axis: .horizontal)
        let testContainer2 = newContainer(elements: [myElements[3], myElements[4], myElements[5]], spacing: 2, axis: .horizontal)
        let testContainer3 = newContainer(elements: [myElements[6], myElements[7], myElements[8]], spacing: 2, axis: .horizontal)
        
        
        let outerContainer = newContainer(elements: [testContainer1, testContainer2], spacing: 3, axis: .vertical)
        outerContainer.addArrangedSubview(testContainer1)
        outerContainer.addArrangedSubview(testContainer2)
        outerContainer.addArrangedSubview(testContainer3)
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
//        outerContainer.backgroundColor = .red
        
        view.addSubview(outerContainer)
        
        NSLayoutConstraint.activate([
            outerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            outerContainer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            outerContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func getCircleView() -> UIView {
        let circle = UIView()
        circle.backgroundColor = .red
        circle.layer.borderWidth = 1
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }
    
    func newContainer(elements: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis)  -> UIStackView {
        let container = UIStackView(arrangedSubviews: elements)
        container.axis = axis
//        container.backgroundColor = .blue
        container.spacing = spacing
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }


}

