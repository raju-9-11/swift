//
//  ViewController.swift
//  Quest3
//
//  Created by Rajkumar S on 08/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        purpleButton.backgroundColor = .purple
        yellowButton.backgroundColor = .yellow
        purpleButton.tintColor = .white
        yellowButton.tintColor = .black
    }
    
    @IBAction func onPurpleClick() {
        view.backgroundColor = .purple
    }
    
    @IBAction func onYellowClick() {
        view.backgroundColor = .yellow
    }


}

