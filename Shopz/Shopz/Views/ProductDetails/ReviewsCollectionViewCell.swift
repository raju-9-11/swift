//
//  ReviewsCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "REVIEWSELEMENTCELL"
    
    let userReviewHeight: CGFloat = 180
    
    weak var delegate: ProductReviewsCellDelegate?
    
    var cellFrame: CGSize = CGSize(width: 100, height: 100)
    
    let reviewList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.register(ReviewItemTableViewCell.self, forCellReuseIdentifier: ReviewItemTableViewCell.cellID)
        return tableView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "text_color")
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reviews"
        return label
    }()
    
    
    
    var reviewElementData: ReviewElement? {
        didSet {
            if reviewElementData != nil {
                self.reviewList.reloadData()
                self.setupLayout()
                self.reviewList.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
        }
    }
    
    func setupLayout() {
        
        reviewList.delegate = self
        reviewList.dataSource = self
        contentView.addSubview(reviewList)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            reviewList.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            reviewList.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            reviewList.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            reviewList.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame
        attr.size.height = CGFloat((reviewElementData?.reviews.count ?? 1) * 120) + 50 + userReviewHeight
        return attr
    }

}

extension ReviewsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID) as! ReviewItemTableViewCell
        cell.review = reviewElementData?.reviews[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return userReviewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let product = reviewElementData?.product, let review = ApplicationDB.shared.hasReviewed(product: product) else { return UIView() }
        let view = MyReviewView(review: review)
        view.delegate = self
        return view
    }
}

extension ReviewsCollectionViewCell: MyReviewViewDelegate {
    
    func updateReview(review: String, rating: Int) {
        guard let product = reviewElementData?.product else { return }
        ApplicationDB.shared.editReview(review: review, rating: rating, product: product)
        delegate?.reviewupDated()
    }
    
    func deleteReview(review: Review?) {
        guard let review = review else {
            return
        }
        ApplicationDB.shared.deleteReview(review: review)
        delegate?.reviewupDated()
    }
    
    func beginEditing(frame: CGRect?) {
        delegate?.editReviewBegan(frame: frame)
    }
    
    func endEditing() {
        delegate?.editReviewEnd()
    }
}

protocol ProductReviewsCellDelegate: AnyObject {
    func reviewupDated()
    func editReviewBegan(frame: CGRect?)
    func editReviewEnd()
}

extension UIButton {
    func setContentMode(mode: UIView.ContentMode) {
        self.imageView?.contentMode = mode
    }
}

class MyReviewView: UIView, UITextViewDelegate {
    
    weak var delegate: MyReviewViewDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profilePic: RoundedImage = {
        let imageView = RoundedImage()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "text_color")
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let reviewView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = UIColor(named: "subtitle_text")
        textview.isEditable = false
        textview.isSelectable = false
        textview.isUserInteractionEnabled = false
        textview.backgroundColor = .clear
        textview.layer.cornerRadius = 8
        textview.layer.borderColor = UIColor.darkGray.cgColor
        textview.layer.borderWidth = 1
        return textview
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
    
    lazy var buttonsView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [editButton, deleteButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    let rating: RatingElement = {
        let rating = RatingElement()
        rating.isEnabled = false
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    var review: Review?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect = .zero, review: Review) {
        super.init(frame: frame)
        self.review = review
        
        nameLabel.text = review.userName
        reviewView.text = review.review
        rating.currentUserRating = review.rating
        
        self.setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor(named: "thumbnail_color")
        self.isUserInteractionEnabled = true
        
        editButton.addTarget(self, action: #selector(onEditClick), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(onDeleteClick), for: .touchUpInside)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(reviewView)
        
        reviewView.delegate = self
        
        self.addSubview(profilePic)
        self.addSubview(containerView)
        self.addSubview(buttonsView)
        self.addSubview(rating)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        NSLayoutConstraint.activate([
            containerView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            containerView.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 5),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            profilePic.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            profilePic.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            profilePic.heightAnchor.constraint(equalToConstant: 25),
            profilePic.widthAnchor.constraint(equalToConstant: 25),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            reviewView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reviewView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rating.topAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: 5),
            rating.centerXAnchor.constraint(equalTo: reviewView.centerXAnchor),
            rating.widthAnchor.constraint(equalTo: reviewView.widthAnchor),
            rating.heightAnchor.constraint(equalToConstant: RatingElement.defHeight),
            buttonsView.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 5),
            buttonsView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            buttonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5 )
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func onKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        if reviewView.isEditable {
            delegate?.beginEditing(frame: notification.name == UIResponder.keyboardDidShowNotification ? keyBoardFrame : .zero)
        }
    }
    
    @objc
    func onKeyboardDisappear(notification : Notification) {
        delegate?.endEditing()
    }
    
    @objc
    func onEditClick() {
        if editButton.title(for: .normal) == "Save Review" {
            if let text = reviewView.text, !text.isEmpty {
                self.reviewView.isSelectable = false
                self.reviewView.isEditable = false
                self.reviewView.isScrollEnabled = false
                self.reviewView.resignFirstResponder()
                self.editButton.setTitle("Edit Review", for: .normal)
                self.rating.isEnabled = false
                delegate?.updateReview(review: text, rating: rating.currentUserRating)
            } else {
                Toast.shared.showToast(message: "Message cannot be empty")
            }
        } else {
            self.reviewView.isSelectable = true
            self.reviewView.isEditable = true
            self.reviewView.isScrollEnabled = true
            self.rating.isEnabled = true
            self.reviewView.becomeFirstResponder()
            self.editButton.setTitle("Save Review", for: .normal)
        }
    }
    
    @objc
    func onDeleteClick() {
        delegate?.deleteReview(review: review)
    }
}

protocol MyReviewViewDelegate: AnyObject {
    func updateReview(review: String, rating: Int)
    func deleteReview(review: Review?)
    func beginEditing(frame: CGRect?)
    func endEditing()
}
