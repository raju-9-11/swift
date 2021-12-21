//
//  ReviewsCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 21/12/21.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    let reviewList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(ReviewItemTableViewCell.self, forCellReuseIdentifier: ReviewItemTableViewCell.cellID)
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reviews"
        return label
    }()
    
    
    var reviewElementData = ReviewElement(reviews: []) {
        willSet {
            self.reviewList.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewElementData.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewItemTableViewCell.cellID) as! ReviewItemTableViewCell
        cell.review = reviewElementData.reviews[indexPath.row]
        return cell
    }
    
    
    
    
    func setupLayout() {
        reviewList.delegate = self
        reviewList.dataSource = self
        contentView.addSubview(reviewList)
        NSLayoutConstraint.activate([
            
        ])
    }
    
}
