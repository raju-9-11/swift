//
//  AddReviewCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class AddReviewCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddREVIEWSELEMENTCELL"
    
    var delegate: ReviewElementDelegate?
    
    var cellFrame: CGSize = CGSize(width: 100, height: 100)

    let addReviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addReviewTextView: TextViewWithPlaceHolder = {
        let textview = TextViewWithPlaceHolder()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.placeholder = "Enter Review"
        return textview
    }()
    
    let addReviewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Review", for: .normal)
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .medium
            config.baseBackgroundColor = UIColor(red: 0.933, green: 0.502, blue: 0.502, alpha: 1)
            button.configuration = config
        } else {
            button.backgroundColor = UIColor(red: 0.933, green: 0.502, blue: 0.502, alpha: 1)
            button.layer.cornerRadius = 6
        }
        return button
    }()
    
    
    func setupLayout() {
        
        addReviewView.addSubview(addReviewTextView)
        addReviewView.addSubview(addReviewButton)
        addReviewButton.addTarget(self, action: #selector(onAddReview), for: .touchUpInside)
        contentView.addSubview(addReviewView)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        NSLayoutConstraint.activate([
            addReviewTextView.topAnchor.constraint(equalTo: addReviewView.topAnchor, constant: 10),
            addReviewTextView.heightAnchor.constraint(equalTo: addReviewView.heightAnchor, multiplier: 0.6),
            addReviewTextView.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.9),
            addReviewTextView.centerXAnchor.constraint(equalTo: addReviewView.centerXAnchor),
            addReviewButton.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.8),
            addReviewButton.centerXAnchor.constraint(equalTo: addReviewView.centerXAnchor),
            addReviewButton.topAnchor.constraint(equalTo: addReviewTextView.bottomAnchor, constant: 10),
            addReviewView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            addReviewView.heightAnchor.constraint(equalToConstant: 150),
            addReviewView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            addReviewView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.contentView.endEditing(true)
    }
    
    @objc
    func onKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        if addReviewTextView.isEditing {
            delegate?.reviewBeginEditing(frame: notification.name == UIResponder.keyboardDidShowNotification ? keyBoardFrame : .zero)
        }
    }
    
    @objc
    func onKeyboardDisappear(notification : Notification) {
        delegate?.reviewDidEndEditing()
    }
    
    
    @objc
    func onAddReview() {
        self.addReviewTextView.text = ""
        delegate?.addReview(review: addReviewTextView.text, rating: 0)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        layoutAttributes.frame.size = CGSize(width: cellFrame.width, height: 200)
        return attr
    }
    
}


protocol ReviewElementDelegate {
    func addReview(review: String, rating: Int)
    func reviewBeginEditing(frame: CGRect?)
    func reviewDidEndEditing()
}

