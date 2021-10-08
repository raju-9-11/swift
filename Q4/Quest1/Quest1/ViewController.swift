//
//  ViewController.swift
//  Quest1
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mySwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onToggle()
        
    }
    
    @IBAction func onToggle() {
        if(mySwitch.isOn) {
            view.backgroundColor = .purple
        } else {
            view.backgroundColor = .yellow
        }
    }


}

