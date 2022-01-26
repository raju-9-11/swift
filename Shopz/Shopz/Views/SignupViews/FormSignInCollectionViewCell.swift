//
//  FormSignInCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 22/12/21.
//

import UIKit

class FormSignInCollectionViewCell: UICollectionViewCell {
    
    static let plainCellID = "formPlainTestnCell"
    
    var delegate: SignInFormCellDelegate? {
        willSet {
            self.setupLayout()
        }
    }
    
    let signInView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account? "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        label.textColor = UIColor(named: "text_color")
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(UIColor(red: 0.692, green: 0.582, blue: 0.582, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    func setupLayout() {
        signInButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        signInView.addArrangedSubview(signInLabel)
        signInView.addArrangedSubview(signInButton)
        contentView.addSubview(signInView)
        NSLayoutConstraint.activate([
            signInView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            signInView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signInView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc
    func buttonClicked() {
        delegate?.sendSignIn()
    }
}

protocol SignInFormCellDelegate {
    func sendSignIn()
}
