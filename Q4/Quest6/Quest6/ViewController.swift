//
//  ViewController.swift
//  Quest6
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class ViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var dateTableView: UITableView!
    var editButton: UIButton!
    var addButton: UIButton!
    var buttonContainer: UIStackView!
    var hour24Switch: UIButton!
    var hour24: Bool = false
    let cellID: String = "customTableCell"
    var countries = CountriesAndTime.time
    var timer: Timer?
    var dateFormatPicker: UIPickerView!
    var timeFormatPicker: UIPickerView!
    var footer: UIStackView!
    var timeFormat = "hh:mm:ss"
    var dateFormat = "dd-MMM-yyyy"

    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        editButton = UIButton(type: .system)
        editButton.setTitle("Edit Table", for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.backgroundColor = .systemTeal
        editButton.setTitleColor(.white, for: .normal)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        editButton.layer.cornerRadius = 4
        
        addButton = UIButton(type: .system)
        addButton.setTitle("Add Entry", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .systemRed
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addButton.layer.cornerRadius = 4
        
        hour24Switch = UIButton(type: .system, primaryAction: UIAction(handler: {
            _ in
            self.hour24 = !self.hour24
            self.hour24Switch.setTitle(!self.hour24 ? "24 Hour" : "12 Hour", for: .normal)
            self.dateTableView.reloadData()
        }))
        hour24Switch.setTitleColor(.white, for: .normal)
        hour24Switch.setTitle("24 Hour", for: .normal)
        hour24Switch.backgroundColor = .systemCyan
        hour24Switch.layer.cornerRadius = 4
        hour24Switch.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationController?.navigationBar.isHidden = true
        
        dateTableView = UITableView()
        dateTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.translatesAutoresizingMaskIntoConstraints = false
        dateTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellID)
        
        buttonContainer = newStackView(elements: [addButton, hour24Switch, editButton], spacing: 10, axis: .horizontal, distribution: .fillEqually, alignment: .center)
        
        dateFormatPicker = UIPickerView()
        dateFormatPicker.dataSource = self
        dateFormatPicker.delegate = self
        
        timeFormatPicker = UIPickerView()
        timeFormatPicker.dataSource = self
        timeFormatPicker.delegate = self
        
        footer = newStackView(elements: [dateFormatPicker, timeFormatPicker], spacing: 10, axis: .horizontal, distribution: .fillEqually, alignment: .fill)
        
        view.addSubview(dateTableView)
        view.addSubview(footer)
        view.addSubview(buttonContainer)
        
        setupLayout()
        
        startUpdate()
        
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let val = countries.remove(at: sourceIndexPath.row)
        countries.insert(val, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let stackView = newStackView(elements: [newLabel(text: "Country", size: 13), newLabel(text: "Day", size: 15), newLabel(text: "Time", size: 15), newLabel(text: "Date", size: 15)], spacing: 10, axis: .horizontal, distribution: .fillEqually, alignment: .fill)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        view.backgroundColor = .black
        return view
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.stopUpdate()
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.startUpdate()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipes = UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Remove", handler: {
            _, _, _ in
            self.countries.remove(at: indexPath.row)
            self.dateTableView.deleteRows(at: [indexPath], with: .fade)
        }),
//            UIContextualAction(style: .normal, title: "Edit", handler: {
//            _, _, _ in
//            self.addTapped()
//        })
        ])
        return swipes
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableViewCell
        countries[indexPath.row].formats = (hour24: hour24, dateFormat: dateFormat, timeFormat: timeFormat)
        cell.data = countries[indexPath.row]
        return cell
    }
    
    
    // MARK: - PickerView Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dateFormatPicker {
            return CountriesAndTime.dateFormats.count
        } else {
            return CountriesAndTime.timeFormats.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dateFormatPicker {
            self.dateFormat = CountriesAndTime.dateFormats[row]
            dateTableView.reloadData()
        } else {
            self.timeFormat = CountriesAndTime.timeFormats[row]
            dateTableView.reloadData()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let string = pickerView == dateFormatPicker ?  CountriesAndTime.dateFormats[row] : CountriesAndTime.timeFormats[row]
        label.text = string
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }
    
    
    
    // MARK: - Init Elements
    
    func newStackView(elements: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: elements)
        stackView.axis = axis
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        return stackView
    }
    
    func newLabel(text: String, size: CGFloat, color: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.text = text
        label.font = .boldSystemFont(ofSize: size)
        return label
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            footer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            footer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            footer.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor),
            footer.heightAnchor.constraint(equalToConstant: 50),
            dateTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateTableView.bottomAnchor.constraint(equalTo: footer.safeAreaLayoutGuide.topAnchor, constant: -10),
            dateTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dateTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func startUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reloadTable), userInfo: nil, repeats: true)
    }
    
    func stopUpdate() {
        timer?.invalidate()
        timer = nil
    }
    
    func addNewRow(with data: DataModel) {
        countries.append(data)
        dateTableView.reloadData()
    }
    
    @objc
    func reloadTable() {
        dateTableView.reloadData()
    }
    
    @objc
    func addTapped() {
        let newVC = NewRowViewController()

        self.present(newVC, animated: true)
    }
    
    @objc
    func editTapped() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
            self.dateTableView.isEditing = !self.dateTableView.isEditing
            self.editButton.setTitle(self.dateTableView.isEditing ? "Done" : "Edit Table", for: .normal)
            self.addButton.isHidden = self.dateTableView.isEditing
            self.hour24Switch.isHidden = self.dateTableView.isEditing
            self.footer.isHidden = self.dateTableView.isEditing
            self.addButton.alpha = self.dateTableView.isEditing ? 0 : 1
            self.hour24Switch.alpha = self.dateTableView.isEditing ? 0 : 1
            self.footer.alpha = self.dateTableView.isEditing ? 0 : 1
        }, completion: nil)
        if self.dateTableView.isEditing {
            self.stopUpdate()
        } else {
            self.startUpdate()
        }
    }
    

}
