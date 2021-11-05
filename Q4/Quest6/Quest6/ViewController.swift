//
//  ViewController.swift
//  Quest6
//
//  Created by Rajkumar S on 27/10/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var dateTableView: UITableView!
    var timeFormatSwitch: UISwitch!
    var editButton: UIButton!
    var addButton: UIButton!
    var buttonContainer: UIStackView!
    let cellID: String = "customTableCell"
    var countries = CountriesAndTime.time
    
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
        
        dateTableView = UITableView()
        dateTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.translatesAutoresizingMaskIntoConstraints = false
        dateTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellID)
        
        buttonContainer = UIStackView(arrangedSubviews: [addButton, editButton])
        buttonContainer.axis = .horizontal
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.distribution = .fillEqually
        buttonContainer.alignment = .center
        buttonContainer.spacing = 10
        view.addSubview(dateTableView)
        view.addSubview(buttonContainer)
        
        NSLayoutConstraint.activate([
            dateTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dateTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dateTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
        ])
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            countries.remove(at: indexPath.row)
            dateTableView.deleteRows(at: [indexPath], with: .fade)
        case .none:
            print("None")
        case .insert:
            print("Inserting ...")
        default:
            print("Default")
        }
        tableView.reloadData()
    }
    
    @objc
    func addTapped() {
        
    }
    
    @objc
    func editTapped() {
        dateTableView.isEditing = !dateTableView.isEditing
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
            self.editButton.setTitle(self.dateTableView.isEditing ? "Done" : "Edit Table", for: .normal)
            self.addButton.isHidden = self.dateTableView.isEditing
            self.addButton.alpha = self.dateTableView.isEditing ? 0 : 1
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableViewCell
        cell.data = countries[indexPath.row]
        return cell
    }
}
