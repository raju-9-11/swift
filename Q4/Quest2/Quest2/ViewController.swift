//
//  ViewController.swift
//  Quest2
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit


class ViewController: UIViewController {
    
    
    var myTextField: UITextView!
    

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
//      TextField initialization
        myTextField = UITextView()
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        myTextField.layer.borderColor = UIColor.darkGray.cgColor
        myTextField.layer.borderWidth = 2
        myTextField.layer.cornerRadius = 5
        myTextField.textAlignment = .center
        view.addSubview(myTextField)
        
//      Menu Initialization
        UIMenuController.shared.menuItems = [
            UIMenuItem(title: "Yellow", action: #selector(onYellow)),
            UIMenuItem(title: "Green", action: #selector(onGreen)),
            UIMenuItem(title: "Blue", action: #selector(onBlue)),
            UIMenuItem(title: "Red", action: #selector(onRed)),
        ]
    
        NSLayoutConstraint.activate([
            myTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            myTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        
    }
    
    @objc
    func onYellow() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: getRange(), color: .yellow)
    }
    
    @objc
    func onRed() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: getRange(), color: .red)
    }
    
    @objc
    func onGreen() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: getRange(), color: .green)
    }
    
    @objc
    func onBlue() {
        myTextField.attributedText = getAttributedText(input: myTextField.attributedText, range: getRange(), color: .blue)
    }
    
    func getRange() -> NSRange {
        var selectedRange = myTextField.selectedRange
        selectedRange.length = nextSpace(from: selectedRange.location + selectedRange.length)
        print(selectedRange.location, selectedRange.length)
        return selectedRange
    }
    
    func nextSpace(from: Int) -> Int {
        guard let string = myTextField.text else { return 0 }
        var count = 0
        var spaceCount = 0
        for index in from..<string.count {
            let stringIndex = string.index(string.startIndex, offsetBy: index)
            if string[stringIndex] == " " {
                spaceCount += 1
            }
            if spaceCount == 2 {
                return myTextField.selectedRange.length + count
            }
            count += 1
        }
        
        return string.count - myTextField.selectedRange.location
        
        
    }
    
    func getAttributedText(input: NSAttributedString?, range: NSRange? , color: UIColor) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString.init(attributedString: input ?? NSAttributedString(string: "Unknown text") )
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor , value: color, range: range ?? NSRange(location: 0, length: 0))
        return mutableString
    }
    
    
}



