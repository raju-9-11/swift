//
//  ViewController.swift
//  Quest2
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTextEnter() {
        let alert = UIAlertController(title: "String Entered", message: myTextField.text ?? "Unknown" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}

