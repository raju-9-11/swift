//
//  ButtonsCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 03/01/22.
//

import UIKit

class CartButtonsCollectionViewCell: UICollectionViewCell {
    
    static let cellID: String = "ButtonsCartCollectionViewCell"
    
    var delegate: ButtonsViewDelegate?
    
    var state: ButtonsViewState = .checkout {
        willSet {
            switch newValue {
            case .all :
                buttonsView.addArrangedSubview(deleteList)
            default:
                buttonsView.isHidden = false
            }
            self.setupLayout()
        }
    }
    
    let checkout: UIButton = {
        let button = UIButton()
        button.setTitle("Checkout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.backgroundColor = UIColor(red: 0.373, green: 0.353, blue: 0.969, alpha: 1)
            button.layer.cornerRadius = 6
        }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let deleteList: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Shopping List", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.backgroundColor = UIColor(red: 0.996, green: 0.924, blue: 0.947, alpha: 1)
            button.layer.cornerRadius = 6
        }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    
    lazy var buttonsView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [checkout])
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 5
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupLayout() {
        contentView.addSubview(buttonsView)
        checkout.addTarget(self, action: #selector(onCheckout), for: .touchUpInside)
        deleteList.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttonsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc
    func onCheckout() {
        delegate?.onCheckout()
    }
    
    @objc
    func onDelete() {
        delegate?.onDelete()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        super.removeViews()
    }
    
}

enum ButtonsViewState {
    case checkout, hidden, all
}

protocol ButtonsViewDelegate {
    func onDelete()
    func onCheckout()
}
