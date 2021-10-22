//
//  ViewController.swift
//  Quest1
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {

    var mySwitch: UISwitch!
    var myLabel: UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .yellow
        
        //Slider initialization
        mySwitch = UISwitch()
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.addTarget(self, action: #selector(onToggle), for: .allEvents)
        mySwitch.isOn = false
        view.addSubview(mySwitch)
        
        //Label initialization
        myLabel = UILabel()
        myLabel.text = " Change Background "
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.textAlignment = .center
        myLabel.font = .italicSystemFont(ofSize: 14)
        myLabel.textColor = .red
        view.addSubview(myLabel)
        
        
        
        NSLayoutConstraint.activate([
            mySwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mySwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        
        ])
        
    }
    
    @objc
    func onToggle(_ sender: UISwitch) {
        if(mySwitch.isOn) {
            view.backgroundColor = .purple
        } else {
            view.backgroundColor = .yellow
        }
    }


}

