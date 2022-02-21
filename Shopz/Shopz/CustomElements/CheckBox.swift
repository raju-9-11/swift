//
//  CheckBox.swift
//  Shopz
//
//  Created by Rajkumar S on 31/12/21.
//

import UIKit

class CheckBox: UIButton {
    
    weak var delegate: CheckBoxDelegate?
    
    let checkBox: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.appTextColor.cgColor
        return view
    }()
    
    var isOn: Bool = false {
        willSet {
            checkBox.image = newValue ? UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate) : nil
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        checkBox.layer.borderColor = UIColor.appTextColor.cgColor
    }
    
    func setupLayout() {
        self.backgroundColor = .clear
        
        
        self.addSubview(checkBox)
        checkBox.isUserInteractionEnabled = false
        self.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            checkBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            checkBox.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
        ])
    }
    
    @objc
    func onClick(sender: UIButton) {
        isOn.toggle()
        self.delegate?.onToggle(self)
    }

}

protocol CheckBoxDelegate: AnyObject {
    func onToggle(_ elem: CheckBox)
}
