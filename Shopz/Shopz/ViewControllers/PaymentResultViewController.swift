//
//  PaymentResultViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentResultViewController: UIViewController {
    
    let goHome: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Home", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        goHome.addTarget(self, action: #selector(onGoHome), for: .touchUpInside)
        
        view.addSubview(goHome)
        
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            goHome.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goHome.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc
    func onGoHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
