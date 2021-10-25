//
//  ViewController.swift
//  Quest5
//
//  Created by Rajkumar S on 25/10/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
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
    var job: UITextField!
    var jobLabel: UILabel!
    var color: UITextField!
    var colorLabel: UILabel!
    var dept: UITextField!
    var deptLabel: UILabel!
    var company: UITextField!
    var companyLabel: UILabel!
    var food: UITextField!
    var foodLabel: UILabel!
    var song: UITextField!
    var songLabel: UILabel!
    
    var myContacts: [Contact] = []
    
    var stack: UIStackView!
    
    var scrollView: UIScrollView!
    
    var submit: UIButton!
    var clear: UIButton!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        
//      person name
        personName = newTextField("Enter Your name")
        
        personNameLabel = newLabel("Name: ")
        
//      dateOfBirth
        dateOfBirth = UIDatePicker()
        dateOfBirth.datePickerMode = .date
        
        dateOfBirthLabel = newLabel("Date of birth: ")
        
//      address
        address = newTextField("Enter Your address")
        
        addressLabel = newLabel("Address: ")
      
//      Phone number
        ph = newTextField("Enter your phone number")
        ph.keyboardType = .numberPad

        phLabel = newLabel("Phone number:")
        
//      Email
        email = newTextField("test@xyz.com")
        
        emailLabel = newLabel("Email: ")
        
//      Job
        job = newTextField("Enter Job title")
        
        jobLabel = newLabel("Job:")
        
//      color
        color = newTextField("Enter your favourite color")
        
        colorLabel = newLabel("Color:")
        
//      song
        song = newTextField("Enter your favourite song")
        
        songLabel = newLabel("Song:")
        
//      department
        dept = newTextField("Enter your department")
        
        deptLabel = newLabel("Department:")
        
//      company
        company = newTextField("Enter Your Company")
        
        companyLabel = newLabel("Company:")
        
//      Food
        food = newTextField("Enter your favourite food")
        
        foodLabel = newLabel("Food:")
        
//      Submit
        submit = UIButton(type: .system)
        submit.setTitle("Done", for: .normal)
        submit.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        
        
//      Clear
        clear = UIButton(type: .system)
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(onClear), for: .touchUpInside)
        
        
        stack = UIStackView(arrangedSubviews: [ newContainer(elements: [personNameLabel, personName], axis: .horizontal, spacing: 0) ,
                                                newContainer(elements: [addressLabel, address], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [dateOfBirthLabel, dateOfBirth], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [phLabel, ph], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [emailLabel, email], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [jobLabel, job], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [deptLabel, dept], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [companyLabel, company], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [songLabel, song], axis: .horizontal, spacing: 0),
                                                newContainer(elements: [foodLabel, food], axis: .horizontal, spacing: 0),
                                              ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.spacing = 5
        stack.distribution = .fillEqually
        
        stack.addArrangedSubview(newContainer(elements: [clear, submit], axis: .horizontal, spacing: 3))
        
        scrollView.addSubview(stack)
        view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -40)
        ])
        
        
        
    }
    
    override func viewDidLoad() {
        ph.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ph {
            let allowedCharset = CharacterSet(charactersIn: "+1234567890")
            return allowedCharset.isSuperset(of: CharacterSet(charactersIn: string))
        }
        return true
    }
    
    func newLabel(_ name: String) -> UILabel {
        let myLabel = UILabel()
        myLabel.text = name
        myLabel.font = .systemFont(ofSize: 12)
        return myLabel
    }
    
    func newTextField(_ placeholder: String) -> UITextField {
        let myTextField = UITextField()
        myTextField.placeholder = placeholder
        myTextField.font = .systemFont(ofSize: 14)
        return myTextField
    }
    
    func newContainer(elements: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let subStack = UIStackView(arrangedSubviews: elements)
        subStack.axis = axis
        subStack.spacing = spacing
        subStack.distribution = .fillEqually
        subStack.alignment = alignment
        return subStack
    }
    
    @objc
    func onSubmit() {
        let alert = UIAlertController(title: "Submitted", message: "Data submitted", preferredStyle: .alert)
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


extension String {
    func isEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
