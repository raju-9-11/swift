//
//  PaymentResultViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class PaymentResultViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 25, weight: .regular)
        label.text = "Payment Success"
        label.textColor = UIColor(named: "text_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goHome: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Home", for: .normal)
        button.setTitleColor(UIColor(named: "text_color"), for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.bordered()
            config.baseBackgroundColor = UIColor(named: "AccentColor")
            config.cornerStyle = .medium
            button.configuration = config
        } else {
            button.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 2
        }
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .systemGreen.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "background_color")
        
        goHome.addTarget(self, action: #selector(onGoHome), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(goHome)
        view.addSubview(titleLabel)
        
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            goHome.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goHome.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
        ])
    }
    
    @objc
    func onGoHome() {
        NotificationCenter.default.post(name: NSNotification.Name.paymentCompletion, object: nil, userInfo: ["Status": "success"])
    }

}
 
