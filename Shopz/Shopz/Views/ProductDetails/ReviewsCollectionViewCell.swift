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
        tableView.isScrollEnabled = false
        tableView.sizeToFit()
        tableView.register(ReviewItemTableViewCell.self, forCellReuseIdentifier: ReviewItemTableViewCell.cellID)
        return tableView
    }()
    
    var reviewListCellHeight: [CGFloat] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reviewList.reloadData()
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appTextColor
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
        willSet {
            if newValue != nil {
                self.reviewList.reloadData()
                self.reviewList.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                self.setupLayout()
            }
            titleLabel.text = newValue?.reviews.count ?? 0 > 0 ? "Reviews" : ""
        }
    }
    
    func setupLayout() {
        
        reviewList.delegate = self
        reviewList.dataSource = self
        contentView.addSubview(reviewList)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.thumbNailColor
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            reviewList.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            reviewList.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            reviewList.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            reviewList.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame
        attr.size.height = cellFrame.height + 50
        return attr
    }

}

extension ReviewsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID, for: indexPath) as! ReviewItemTableViewCell
        cell.review = reviewElementData?.reviews[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < reviewListCellHeight.count {
            return reviewListCellHeight[indexPath.row]
        }
        return 100
    }
    
}

extension UIButton {
    func setContentMode(mode: UIView.ContentMode) {
        self.imageView?.contentMode = mode
    }
}
