//
//  SellerHomeBodyCell.swift
//  Shopz
//
//  Created by Rajkumar S on 27/01/22.
//

import UIKit

class SellerHomeBodyCell: UITableViewCell {
    
    static let cellID = "SELLERBOdyellid"

    var productData: [Product] = [] {
        willSet {
            self.setupLayout()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var itemSize: CGSize? {
        willSet {
            if newValue != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        cv.register(ItemThumbNailCollectionViewCell.self, forCellWithReuseIdentifier: ItemThumbNailCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    func setupLayout() {
        
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }

}

extension SellerHomeBodyCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemThumbNailCollectionViewCell.cellID, for: indexPath) as! ItemThumbNailCollectionViewCell
        cell.data = productData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize ?? CGSize(width: 100, height: 100)
    }
    
}
