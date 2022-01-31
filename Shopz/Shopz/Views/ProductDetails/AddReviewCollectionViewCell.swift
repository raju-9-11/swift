//
//  AddReviewCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

internal var ADD_REVIEW_CELL_HEIGHT: CGFloat = 200

class AddReviewCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddREVIEWSELEMENTCELL"
    
    weak var delegate: ReviewElementDelegate?
    
    var cellFrame: CGSize = CGSize(width: 100, height: 100)
    
    var images: [UIImage] = [] {
        willSet {
            imagesView.isHidden = newValue.isEmpty
            self.delegate?.imagesChanged(newValue.isEmpty)
        }
    }

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
    
    let imagesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .red
        cv.isHidden = true
        return cv
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        button.tintColor = UIColor(named: "text_color")
        button.setContentMode(mode: .scaleAspectFit)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rating: RatingElement = {
        let ratingElem = RatingElement()
        ratingElem.translatesAutoresizingMaskIntoConstraints = false
        return ratingElem
    }()
    
    
    func setupLayout() {
        
        addReviewView.addSubview(rating)
        addReviewView.addSubview(addReviewTextView)
        addReviewView.addSubview(addReviewButton)
        addReviewView.addSubview(addImageButton)
        
        addReviewButton.addTarget(self, action: #selector(onAddReview), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(onAddImage), for: .touchUpInside)
        
        contentView.addSubview(imagesView)
        contentView.addSubview(addReviewView)
        
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        NSLayoutConstraint.activate([
            rating.topAnchor.constraint(equalTo: addReviewView.topAnchor),
            rating.centerXAnchor.constraint(equalTo: addReviewTextView.centerXAnchor),
            rating.widthAnchor.constraint(equalTo: addReviewTextView.widthAnchor, constant: -5),
            rating.heightAnchor.constraint(equalToConstant: RatingElement.defHeight),
            addReviewTextView.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 10),
            addReviewTextView.heightAnchor.constraint(equalTo: addReviewView.heightAnchor, multiplier: 0.5),
            addReviewTextView.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.9),
            addReviewTextView.centerXAnchor.constraint(equalTo: addReviewView.centerXAnchor),
            addReviewButton.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.6),
            addReviewButton.leftAnchor.constraint(equalTo: addReviewTextView.leftAnchor),
            addImageButton.leftAnchor.constraint(equalTo: addReviewButton.rightAnchor, constant: 5),
            addImageButton.centerYAnchor.constraint(equalTo: addReviewButton.centerYAnchor),
            addReviewButton.topAnchor.constraint(equalTo: addReviewTextView.bottomAnchor, constant: 10),
            addReviewView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            addReviewView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            addReviewView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            addReviewView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    @objc
    func onAddImage() {
        delegate?.addImageClicked(sender: addImageButton, delegateSource: self)
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
        delegate?.addReview(review: addReviewTextView.text, rating: rating.currentUserRating)
        self.addReviewTextView.text = ""
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        layoutAttributes.frame.size = CGSize(width: cellFrame.width, height: ADD_REVIEW_CELL_HEIGHT)
        return attr
    }
    
}

extension AddReviewCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else { return }
        images.append(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }

    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}


protocol ReviewElementDelegate: AnyObject {
    func addReview(review: String, rating: Int)
    func reviewBeginEditing(frame: CGRect?)
    func reviewDidEndEditing()
    func addImageClicked(sender: UIView, delegateSource: AddReviewCollectionViewCell)
    func imagesChanged(_ hasImages: Bool)
}

