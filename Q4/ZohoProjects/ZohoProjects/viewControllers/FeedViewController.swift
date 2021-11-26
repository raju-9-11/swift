//
//  FeedViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: {
            _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        button.setTitle("Get out", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    

}
