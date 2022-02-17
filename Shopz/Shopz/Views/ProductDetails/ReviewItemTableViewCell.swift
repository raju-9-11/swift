//
//  ReviewItemTableViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewItemTableViewCell: UITableViewCell {
    
    static let cellID = "ReviewITemCELL"
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isPreview: Bool = false {
        willSet {
            imagesView.isHidden = newValue
        }
    }
    
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
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let reviewView: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = UIColor(named: "subtitle_text")
        textview.isEditable = false
        textview.font = .systemFont(ofSize: 12, weight: .regular)
        textview.isSelectable = false
        textview.isUserInteractionEnabled = false
        textview.backgroundColor = .clear
        return textview
    }()
    
    
    let rating: RatingElement = {
        let rating = RatingElement()
        rating.isEnabled = false
        rating.translatesAutoresizingMaskIntoConstraints = false
        return rating
    }()
    
    var review: Review? {
        willSet {
            if newValue != nil {
                self.reviewMedia = ApplicationDB.shared.getReviewMediaList(review: newValue!)
                reviewView.text = newValue?.review
                nameLabel.text = newValue?.userName
                rating.currentUserRating = newValue!.rating
            }
            self.setupLayout()
        }
    }
    
    var reviewMedia: [ApplicationDB.ReviewMedia] = [] {
        willSet {
            self.imagesView.isHidden = newValue.isEmpty
            DispatchQueue.main.async {
                self.imagesView.reloadData()
            }
        }
    }
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupLayout() {
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        imagesView.delegate = self
        imagesView.dataSource = self
        
        
        contentView.addSubview(profilePic)
        containerView.addSubview(nameLabel)
        containerView.addSubview(reviewView)
        containerView.addSubview(rating)
        containerView.addSubview(imagesView)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20),
            containerView.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: 5),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profilePic.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profilePic.heightAnchor.constraint(equalToConstant: 25),
            profilePic.widthAnchor.constraint(equalToConstant: 25),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            reviewView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            reviewView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            reviewView.bottomAnchor.constraint(equalTo: rating.topAnchor),
            imagesView.bottomAnchor.constraint(equalTo: rating.topAnchor),
            imagesView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            imagesView.heightAnchor.constraint(equalToConstant: 100),
            imagesView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            rating.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rating.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            rating.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            rating.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }

}

extension ReviewItemTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddReviewImageCollectionViewCell.cellID, for: indexPath) as! AddReviewImageCollectionViewCell
        cell.isEnabled = false
        cell.media = reviewMedia[indexPath.row]
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
