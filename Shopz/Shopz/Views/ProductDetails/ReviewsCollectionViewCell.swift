//
//  ReviewsCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "REVIEWSELEMENTCELL"
    
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
    
    
    
    var reviewElementData: ReviewElement? {
        didSet {
            if reviewElementData != nil {
                self.reviewList.reloadData()
                self.setupLayout()
                self.reviewList.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            }
            titleLabel.text = reviewElementData?.reviews.count ?? 0 > 0 ? "Reviews" : ""
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
        attr.size.height = CGFloat((reviewElementData?.reviews.count ?? 1) * 170) + 50
        return attr
    }

}

extension ReviewsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData?.reviews.count ?? 0
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID) as! ReviewItemTableViewCell
        cell.review = reviewElementData?.reviews[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
}

extension UIButton {
    func setContentMode(mode: UIView.ContentMode) {
        self.imageView?.contentMode = mode
    }
}
