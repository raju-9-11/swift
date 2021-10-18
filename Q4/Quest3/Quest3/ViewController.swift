//
//  ViewController.swift
//  Quest3
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    var purpleButton: UIButton!
    var yellowButton: UIButton!

    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
//      Purple button initialization
        purpleButton = UIButton(type: .system)
        purpleButton.setTitle("Purple Button", for: .normal)
        purpleButton.backgroundColor = .purple
        purpleButton.translatesAutoresizingMaskIntoConstraints = false
        purpleButton.setTitleColor(.black, for: .normal)
        purpleButton.tintColor = .black
        view.addSubview(purpleButton)
        
//      Yellow Button Initialization
        yellowButton = UIButton(type: .system)
        yellowButton.setTitle("Yellow Button", for: .normal)
        yellowButton.setTitleColor(.black, for: .normal)
        yellowButton.translatesAutoresizingMaskIntoConstraints = false
        yellowButton.backgroundColor = .yellow
        yellowButton.tintColor = .black
        view.addSubview(yellowButton)
        
        NSLayoutConstraint.activate([
            purpleButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            purpleButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            purpleButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            yellowButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            yellowButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            yellowButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        
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

