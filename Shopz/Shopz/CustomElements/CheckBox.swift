//
//  CheckBox.swift
//  Shopz
//
//  Created by Rajkumar S on 31/12/21.
//

import UIKit

class CheckBox: UIButton {
    
    weak var delegate: CheckBoxDelegate?
    
    let checkBox: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    var isOn: Bool = false {
        willSet {
            checkBox.backgroundColor = newValue ? .black : .red
            self.delegate?.onToggle(self)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(checkBox)
        checkBox.isUserInteractionEnabled = false
        self.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            checkBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBox.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            checkBox.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
        ])
    }
    
    @objc
    func onClick(sender: UIButton) {
        isOn.toggle()
    }

}

protocol CheckBoxDelegate: AnyObject {
    func onToggle(_ elem: CheckBox)
}
