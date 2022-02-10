//
//  AddReviewCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class AddReviewCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "AddREVIEWSELEMENTCELL"
    
    weak var delegate: ReviewElementDelegate?
    
    var cellFrame: CGSize = CGSize(width: 100, height: 100)
    
    var review: Review? {
        willSet {
            addReviewTextView.isEnabled = newValue == nil
            rating.isEnabled = newValue == nil
            if newValue != nil {
                stackView.insertArrangedSubview(titleLabel, at: 0)
                rating.currentUserRating = newValue?.rating ?? 1
                addReviewTextView.text = newValue?.review ?? ""
                addButtons.addArrangedSubview(editButton)
                addButtons.addArrangedSubview(deleteButton)
                DispatchQueue.main.async {
                    self.reviewMedia = ApplicationDB.shared.getReviewMediaList(review: newValue!)
                    if self.editButton.title(for: .normal) == "Save" {
                        self.addReviewTextView.isEnabled = true
                        self.rating.isEnabled = true
                        self.addButtons.addArrangedSubview(self.addImageButton)
                        self.addButtons.addArrangedSubview(self.cancelButton)
                    }
                }
            } else {
                addButtons.addArrangedSubview(addReviewButton)
                addButtons.addArrangedSubview(addImageButton)
                titleLabel.removeFromSuperview()
            }
            self.setupLayout()
        }
    }
    
    var reviewMedia: [ApplicationDB.ReviewMedia] = [] {
        willSet {
            self.imagesView.isHidden = newValue.isEmpty
            if self.reviewMedia.isEmpty != newValue.isEmpty && (addReviewView.superview != nil || editButton.title(for: .normal) == "Save") {
                self.layoutSubviews()
                self.layoutIfNeeded()
                self.delegate?.imagesChanged(newValue.isEmpty)
            }
            DispatchQueue.main.async {
                self.imagesView.reloadData()
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Review"
        return label
    }()

    let addReviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
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
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = UIColor(named: "text_color")
        button.setContentMode(mode: .scaleAspectFit)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let imagesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AddReviewImageCollectionViewCell.self, forCellWithReuseIdentifier: AddReviewImageCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.isHidden = true
        return cv
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        button.tintColor = UIColor(named: "text_color")
        button.setContentMode(mode: .scaleAspectFit)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.setTitle("Edit Review", for: .normal)
        button.setContentMode(mode: .scaleAspectFit)
        button.tintColor = UIColor(named: "text_color")
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "delete.left"), for: .normal)
        button.setTitle("Delete", for: .normal)
        button.setContentMode(mode: .scaleAspectFit)
        button.tintColor = UIColor(named: "text_color")
        return button
    }()
    
    let rating: RatingElement = {
        let ratingElem = RatingElement()
        ratingElem.translatesAutoresizingMaskIntoConstraints = false
        return ratingElem
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var addButtons: UIStackView = {
        return getStack(views: [], axis: .horizontal, dist: .fillProportionally)
    }()
    
    func setupLayout() {
        
        addReviewButton.addTarget(self, action: #selector(onAddReview), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(onAddImage), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(onEditClick), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteReview), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        stackView.addArrangedSubview(addReviewTextView)
        stackView.addArrangedSubview(rating)
        stackView.addArrangedSubview(imagesView)
        stackView.addArrangedSubview(addButtons)
        
        imagesView.delegate = self
        imagesView.dataSource = self
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            addReviewTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            addReviewTextView.heightAnchor.constraint(equalToConstant: 80),
            rating.heightAnchor.constraint(equalToConstant: RatingElement.defHeight),
            imagesView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.contentView.endEditing(true)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
        self.addReviewTextView.text = ""
        self.addReviewTextView.isEnabled = true
        self.rating.isEnabled = true
        addButtons.arrangedSubviews.forEach({ $0.removeFromSuperview()})
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        layoutAttributes.frame.size = CGSize(width: cellFrame.width, height: stackView.frame.height)
        return attr
    }
    
    @objc
    func onEditClick() {
        if editButton.title(for: .normal) == "Edit Review" {
            self.imagesView.reloadData()
            editButton.setTitle("Save", for: .normal)
            self.addReviewTextView.isEnabled = true
            self.rating.isEnabled = true
            self.addButtons.addArrangedSubview(addImageButton)
            self.addButtons.addArrangedSubview(cancelButton)
            addReviewTextView.makeFirstResponder()
        } else {
            if !addReviewTextView.text.isEmpty {
                editButton.setTitle("Edit Review", for: .normal)
                self.addReviewTextView.isEnabled = false
                self.rating.isEnabled = false
                addImageButton.removeFromSuperview()
                cancelButton.removeFromSuperview()
                guard let review = review else {
                    return
                }
                delegate?.editReview(oldReview: review, rating: rating.currentUserRating, review: addReviewTextView.text, media: reviewMedia)
            } else {
                Toast.shared.showToast(message: "Review Cannot be Empty")
            }
            
            self.imagesView.reloadData()
        }
    }
    
    @objc
    func onCancelClick() {
        addReviewTextView.text = review?.review ?? ""
        editButton.setTitle("Edit Review", for: .normal)
        self.addReviewTextView.isEnabled = false
        self.rating.isEnabled = false
        addImageButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        guard let review = review else {
            return
        }
        self.reviewMedia = ApplicationDB.shared.getReviewMediaList(review: review)
        self.imagesView.reloadData()
    }
    
    @objc
    func onAddImage() {
        delegate?.addImageClicked(sender: addImageButton, delegateSource: self)
    }
    
    
    func getStack(views: [UIView], axis: NSLayoutConstraint.Axis, dist: UIStackView.Distribution, spacing: CGFloat = 2) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.distribution = dist
        stack.spacing = spacing
        return stack
    }
    
    @objc
    func deleteReview() {
        guard let review = review else {
            return
        }
        reviewMedia = []
        delegate?.deleteReview(review)
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
        if !addReviewTextView.text.isEmpty {
            delegate?.addReview(review: addReviewTextView.text, rating: rating.currentUserRating, media: reviewMedia)
            self.addReviewTextView.text = ""
            imagesView.reloadData()
        } else {
            Toast.shared.showToast(message: "Review cannot be empty")
        }
    }
    
}

extension AddReviewCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddReviewImageCollectionViewCell.cellID, for: indexPath) as! AddReviewImageCollectionViewCell
        cell.delegate = self
        cell.isEnabled = (review == nil) ? true : editButton.title(for: .normal) == "Save" ? true : false
        cell.media = reviewMedia[indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}

extension AddReviewCollectionViewCell: AddReviewImageDelegate {
    func deleteImage(at index: IndexPath) {
        guard index.row < reviewMedia.count else { return }
        imagesView.performBatchUpdates({
            self.reviewMedia.remove(at: index.row)
            self.imagesView.deleteItems(at: [index])
        }, completion: {
            _ in
            self.imagesView.reloadData()
        })
        
    }
}

extension AddReviewCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if picker.mediaTypes.contains("public.movie"), let fileURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? NSURL {
            reviewMedia.append(ApplicationDB.ReviewMedia(mediaUrl: fileURL as URL, mediaId: -1, reviewId: -1, type: .video))
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let _ = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage, let fileURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? NSURL else { picker.dismiss(animated: true, completion: nil); return }
        reviewMedia.append(ApplicationDB.ReviewMedia(mediaUrl: fileURL as URL, mediaId: -1, reviewId: -1, type: .image))
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
    func addReview(review: String, rating: Int, media: [ApplicationDB.ReviewMedia])
    func reviewBeginEditing(frame: CGRect?)
    func reviewDidEndEditing()
    func editReview(oldReview: Review, rating: Int, review: String, media: [ApplicationDB.ReviewMedia])
    func deleteReview(_ review: Review)
    func addImageClicked(sender: UIView, delegateSource: AddReviewCollectionViewCell)
    func imagesChanged(_ hasImages: Bool)
}

