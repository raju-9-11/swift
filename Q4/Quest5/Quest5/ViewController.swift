//
//  ViewController.swift
//  Quest5
//
//  Created by Rajkumar S on 25/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    var personName: UITextField!
    var personNameLabel: UILabel!
    var dateOfBirth: UIDatePicker!
    var dateOfBirthLabel: UILabel!
    var address: UITextField!
    var addressLabel: UILabel!
    var ph: UITextField!
    var phLabel: UILabel!
    var email: UITextField!
    var emailLabel: UILabel!
    var stack: UIStackView!
    
    var submit: UIButton!
    var clear: UIButton!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
//      person name
        personName = UITextField()
        personName.placeholder = "Enter your name"
        
        personNameLabel = newLabel("Name: ")
        
//      dateOfBirth
        dateOfBirth = UIDatePicker()
        
        dateOfBirthLabel = newLabel("Date of birth: ")
        
//      address
        address = UITextField()
        address.placeholder = "Enter Your address"
        
        addressLabel = newLabel("Address: ")
      
//      Phone number
        ph = UITextField()
        ph.placeholder = "Enter Phone number"
        
        phLabel = newLabel("Phone number")
        
        
//      Submit
        submit = UIButton(type: .system)
        submit.setTitle("Done", for: .normal)
        submit.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        
        
//      Clear
        clear = UIButton(type: .system)
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(onClear), for: .touchUpInside)
        
        
        stack = UIStackView(arrangedSubviews: [ personNameLabel, personName, dateOfBirth, addressLabel, address, phLabel, ph, clear, submit])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.spacing = 5
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        
        
    }
    
    func newLabel(_ name: String) -> UILabel {
        var myLabel = UILabel()
        myLabel.text = name
        myLabel.font = .systemFont(ofSize: 10)
        return myLabel
    }
    
    @objc
    func onSubmit() {
        let alert = UIAlertController(title: "Submitted", message: "Data submitted ", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: {
            _ in
            self.onClear()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc
    func onClear() {
        
    }


}

