//
//  ViewController.swift
//  Quest2
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    var myTextField: UITextField!

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
//      TextField initialization
        myTextField = UITextField()
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        myTextField.placeholder = "Test"
        myTextField.borderStyle = .roundedRect
        myTextField.textAlignment = .center
        view.addSubview(myTextField)
        
//      Menu Initialization
        UIMenuController.shared.menuItems = [  UIMenuItem(title: "Yellow", action: #selector(onYellow)),
                                               UIMenuItem(title: "Green", action: #selector(onGreen)),
                                               UIMenuItem(title: "Blue", action: #selector(onBlue)),
                                               UIMenuItem(title: "Red", action: #selector(onRed)),
                                            ]
    
        NSLayoutConstraint.activate([
            myTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8, constant: -100),
        ])
        
    }
    
    @objc
    func onYellow() {
        myTextField.selectedTextRange?.replacementObject(for: <#T##NSKeyedArchiver#>)
        myTextField.textColor = .yellow
    }
    
    @objc
    func onRed() {
        myTextField.textColor = .red
    }
    
    @objc
    func onGreen() {
        myTextField.textColor = .green
    }
    
    @objc
    func onBlue() {
        myTextField.textColor = .blue
    }
    
}

