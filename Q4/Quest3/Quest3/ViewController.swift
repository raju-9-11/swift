//
//  ViewController.swift
//  Quest3
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    var purpleButton: CustomButton!
    var yellowButton: CustomButton!

    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
//      Purple button initialization
        purpleButton = CustomButton(type: .system)
        purpleButton.data = (text: "Purple", color: .purple)
        purpleButton.translatesAutoresizingMaskIntoConstraints = false
        purpleButton.setTitleColor(.black, for: .normal)
        view.addSubview(purpleButton)
        
//      Yellow Button Initialization
        yellowButton = CustomButton(type: .system)
        yellowButton.data = (text: "Yellow", color: .yellow)
        yellowButton.setTitleColor(.black, for: .normal)
        yellowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yellowButton)
        
        NSLayoutConstraint.activate([
            purpleButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            purpleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            purpleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            purpleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yellowButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            yellowButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            yellowButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            yellowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        purpleButton.addTarget(self, action: #selector(onPurpleClick), for: .touchUpInside)
        yellowButton.addTarget(self, action: #selector(onYellowClick), for: .touchUpInside)
        
    }
    
    @objc
    func onPurpleClick() {
        view.backgroundColor = .purple
    }
    
    @objc
    func onYellowClick() {
        view.backgroundColor = .yellow
    }


}

