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
        contentView.backgroundColor = UIColor(named: "thumbnail_color")
        reviewList.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
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
        attr.size.height = CGFloat(reviewElementData.reviews.count * 120)
        return attr
    }

}
