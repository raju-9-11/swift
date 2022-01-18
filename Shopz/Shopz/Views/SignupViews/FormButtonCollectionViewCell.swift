//
//  FormButtonCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import UIKit

class FormButtonCollectionViewCell: UICollectionViewCell {
    
    static let buttonCellID = "formbuttonitemCell"
    
    var delegate: SubmitButtonDelegate?
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            config.cornerStyle = .medium
            config.baseBackgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.layer.cornerRadius = 6
        }
        return button
    }()
    
    var buttonComponentProp: ButtonElement = ButtonElement(title: "", index: -1) {
        willSet {
            self.button.setTitle(newValue.title, for: .normal)
            self.setupLayout()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    func setupLayout() {
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc
    func buttonClicked() {
        delegate?.sendSubmit(buttonProp: self.buttonComponentProp)
    }
    

}

protocol SubmitButtonDelegate {
    func sendSubmit(buttonProp: ButtonElement)
}
