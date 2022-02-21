//
//  ProfileReviewsViewCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 31/01/22.
//

import UIKit

class ProfileReviewsViewCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ProfileReviewListContainerCell"
    
    weak var delegate: ProfileReviewsViewDelegate?
    
    var cellFrame: CGRect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
    
    let reviewList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = true
        tableView.register(ReviewItemTableViewCell.self, forCellReuseIdentifier: ReviewItemTableViewCell.cellID)
        return tableView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appTextColor
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reviews"
        return label
    }()
    
    
    
    var reviewElementData: ProfileReviewListElemrnt? {
        didSet {
            if reviewElementData != nil {
                self.reviewList.reloadData()
                self.setupLayout()
            }
        }
    }
    
    func setupLayout() {
        
        reviewList.delegate = self
        reviewList.dataSource = self
        contentView.addSubview(reviewList)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.thumbNailColor
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            reviewList.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            reviewList.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            reviewList.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            reviewList.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame.size
        attr.size.height = CGFloat((reviewElementData?.reviews.count ?? 1) * 150)
        return attr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}

extension ProfileReviewsViewCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID, for: indexPath) as! ReviewItemTableViewCell
        cell.review = reviewElementData?.reviews[indexPath.row]
        cell.isPreview = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let review = reviewElementData?.reviews[indexPath.row], let product = StorageDB.getProduct(with: review.productId) {
            delegate?.reviewSelect(review: review, product: product)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

protocol ProfileReviewsViewDelegate: AnyObject {
    func reviewSelect(review: Review, product: Product)
}
