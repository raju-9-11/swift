//
//  NewRowViewController.swift
//  Quest6
//
//  Created by Rajkumar S on 08/11/21.
//

import UIKit

class NewRowViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var addRowButton: UIButton!
    var cancelButton: UIButton!
    var countryPickerLabel: UILabel!
    var countryPicker: UIPickerView!
    var titleLabel: UILabel!
    var countries = Array(CountriesAndTime.countries.keys)

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.text = "Add Row"
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        addRowButton = UIButton(type: .system, primaryAction: UIAction(handler: {
            _ in
            self.addRow()
        }))
        addRowButton.setTitle("Add", for: .normal)
        addRowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addRowButton)
        
        cancelButton = UIButton(type: .system, primaryAction: UIAction(handler: {
            _ in
            self.returnToMain()
        }))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        countryPicker = UIPickerView()
        countryPicker.translatesAutoresizingMaskIntoConstraints = false
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.backgroundColor = .clear
        view.addSubview(countryPicker)
        
        countryPickerLabel = UILabel()
        countryPickerLabel.text = "Select a country: "
        countryPickerLabel.textColor = .black
        countryPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        countryPickerLabel.font = .boldSystemFont(ofSize: 15)
        view.addSubview(countryPickerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            addRowButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addRowButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cancelButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            countryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countryPicker.heightAnchor.constraint(equalToConstant: 100),
            countryPickerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryPickerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    
    func newContainer(elements: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .leading) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: elements)
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fillEqually
        stack.alignment = alignment
        return stack
    }

    func returnToMain() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addRow() {
        let index = countryPicker.selectedRow(inComponent: 0)
        if let pc = presentingViewController as? ViewController {
            guard let timeZone = CountriesAndTime.countries[countries[index]] else { print("Failed"); return }
            pc.addNewRow(with: DataModel(country: countries[index], timeZone: timeZone, day: localDay(in: timeZone), hour24: pc.hour24))
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
