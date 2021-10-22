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
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: myTextField.selectedRange, color: .yellow)
    }
    
    @objc
    func onRed() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: myTextField.selectedRange, color: .red)
    }
    
    @objc
    func onGreen() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: myTextField.selectedRange, color: .green)
    }
    
    @objc
    func onBlue() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: myTextField.selectedRange, color: .blue)
    }
    
    func getAttributedText(input: NSAttributedString?, range: NSRange? , color: UIColor) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString.init(attributedString: input ?? NSAttributedString(string: "Unknown text") )
        let range = myTextField.selectedRange
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor , value: color, range: range ?? NSRange(location: 0, length: 0))
        return mutableString
    }
    
    
}


extension UITextField {
    var selectedRange: NSRange? {
        guard let range = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}
