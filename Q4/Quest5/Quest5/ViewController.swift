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
    var titleLabel: UILabel!
    var totalContactsLabel: UILabel!
    
    
    var myContacts: [Contact] = [] {
        didSet {
            totalContactsLabel.text = "Total Contacts Entered: \(myContacts.count)"
        }
    }
    
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
        
//      TtielLabel
        titleLabel = newLabel("Create Contact")
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
//      Contacts label
        totalContactsLabel = newLabel("Total Contacts Entered: \(myContacts.count)")

        
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
        submit.contentHorizontalAlignment = .right
        
        
//      Clear
        clear = UIButton(type: .system)
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(onClear), for: .touchUpInside)
        clear.contentHorizontalAlignment = .left


        stack = UIStackView(arrangedSubviews: [
            newContainer(elements: [clear, titleLabel, submit], axis: .horizontal, spacing: 0, alignment: .fill),
            newContainer(elements: [personNameLabel, personName], axis: .vertical, spacing: 0),
            newContainer(elements: [addressLabel, address], axis: .vertical, spacing: 0),
            newContainer(elements: [dateOfBirthLabel, dateOfBirth], axis: .vertical, spacing: 0),
            newContainer(elements: [phLabel, ph], axis: .vertical, spacing: 0),
            newContainer(elements: [emailLabel, email], axis: .vertical, spacing: 0),
            newContainer(elements: [jobLabel, job], axis: .vertical, spacing: 0),
            newContainer(elements: [deptLabel, dept], axis: .vertical, spacing: 0),
            newContainer(elements: [companyLabel, company], axis: .vertical, spacing: 0),
            newContainer(elements: [songLabel, song], axis: .vertical, spacing: 0),
            newContainer(elements: [foodLabel, food], axis: .vertical, spacing: 0),
            newContainer(elements: [totalContactsLabel], axis: .vertical, spacing: 0)
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.spacing = 3
        stack.distribution = .fillEqually
        
        
        scrollView.addSubview(stack)
        view.addSubview(scrollView)
        
        
        setUpLayout()
        
        
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
    
    
    func setUpLayout() {
        //Scrollview constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        //Stackview Constraints
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    
    
    func newLabel(_ name: String) -> UILabel {
        let myLabel = UILabel()
        myLabel.text = name
        myLabel.font = .boldSystemFont(ofSize: 14)
        return myLabel
    }
    
    func newTextField(_ placeholder: String) -> UITextField {
        let myTextField = UITextField()
        myTextField.placeholder = placeholder
        myTextField.font = .systemFont(ofSize: 16)
        return myTextField
    }
    
    func newContainer(elements: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .leading) -> UIStackView {
        let subStack = UIStackView(arrangedSubviews: elements)
        subStack.axis = axis
        subStack.spacing = spacing
        subStack.distribution = .fillEqually
        subStack.alignment = alignment
        return subStack
    }
    
    @objc
    func onSubmit() {
        
        let newContact = Contact(name: personName.text!, address: address.text!, dob: dateOfBirth.date, color: color.text!, dept: dept.text!, company: company.text!, food: food.text!, song: song.text!, email: email.text!)
        if newContact.isValid() {
            let alert = UIAlertController(title: "Submitted", message: "Contact added", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: {
                _ in
                self.onClear()
            })
            alert.addAction(action)
            present(alert, animated: true)
            myContacts.append(newContact)
        }
        else {
            let alert = UIAlertController(title: "Error adding contact", message: "Error in form", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay ! Let me Check", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    func onClear() {
        ph.text = ""
        song.text = ""
        food.text = ""
        email.text = ""
        color.text = ""
        job.text = ""
        dept.text = ""
        company.text = ""
        address.text = ""
        personName.text = ""
        
    }


}
