//
//  ReviewsCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    static let cellID = "REVIEWSELEMENTCELL"
    
    var cellFrame: CGSize = CGSize(width: 100, height: 100)
    
    var addReviewEnabled: Bool = true {
        willSet {
            if newValue {
                addReviewView.isHidden = false
            } else {
                addReviewView.isHidden = true
            }
        }
    }
    
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
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reviews"
        return label
    }()
    
    let addReviewView: UIView = {
        let view = UIView()
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
    
    
    var reviewElementData = ReviewElement(reviews: []) {
        didSet {
            self.reviewList.reloadData()
            self.setupLayout()
            self.reviewList.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID) as! ReviewItemTableViewCell
        cell.review = reviewElementData.reviews[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func setupLayout() {
        reviewList.delegate = self
        reviewList.dataSource = self
        contentView.addSubview(reviewList)
        contentView.addSubview(titleLabel)
        addReviewView.addSubview(addReviewTextView)
        addReviewView.addSubview(addReviewButton)
        addReviewTextView.refreshControl?.addTarget(self, action: #selector(onText), for: .allEvents)
        contentView.addSubview(addReviewView)
        reviewList.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            reviewList.topAnchor.constraint(equalTo: addReviewView.bottomAnchor, constant: 20),
            reviewList.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            reviewList.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            reviewList.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addReviewView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addReviewView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            addReviewView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            addReviewView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addReviewTextView.topAnchor.constraint(equalTo: addReviewView.topAnchor, constant: 10),
            addReviewTextView.heightAnchor.constraint(equalTo: addReviewView.heightAnchor, multiplier: 0.6),
            addReviewTextView.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.9),
            addReviewTextView.centerXAnchor.constraint(equalTo: addReviewView.centerXAnchor),
            addReviewButton.widthAnchor.constraint(equalTo: addReviewView.widthAnchor, multiplier: 0.8),
            addReviewButton.centerXAnchor.constraint(equalTo: addReviewView.centerXAnchor),
            addReviewButton.topAnchor.constraint(equalTo: addReviewTextView.bottomAnchor, constant: 10),
            addReviewButton.heightAnchor.constraint(equalTo: addReviewView.heightAnchor, multiplier: 0.2),
        ])
    }
    
    @objc
    func onText(sender: UITextView) {
        print("Words")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reviewList.reloadData()
        addReviewView.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame
        addReviewView.sizeToFit()
        addReviewView.layoutSubviews()
        addReviewView.layoutIfNeeded()
        attr.size.height = CGFloat(reviewElementData.reviews.count * 100) + 250
        return attr
    }

}

class TextViewWithPlaceHolder: UITextView, UITextViewDelegate {
    
    var placeholder: String = "" {
        willSet {
            if text.isEmpty {
                text = newValue
                textColor = UIColor.lightGray
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}
