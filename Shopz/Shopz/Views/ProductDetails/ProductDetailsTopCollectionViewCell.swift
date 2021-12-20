//
//  ProductDetailsTopCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class ProductDetailsTopCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var delegate: ImagesViewDelegate?
    
    var imageData = ImagesViewElement(images: []) {
        willSet {
            self.setupLayout()
        }
    }
    
    static let cellID = "TopCellProduct"
    
    var cellFrame = CGSize(width: 100, height: 100)
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(ProductViewCellCollectionViewCell.self, forCellWithReuseIdentifier: ProductViewCellCollectionViewCell.cellID)
        return cv
    }()
    
    
    func setupLayout() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductViewCellCollectionViewCell.cellID, for: indexPath) as! ProductViewCellCollectionViewCell
        cell.data = imageData.images[indexPath.row]
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendImage(imageData.images[indexPath.row])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size = cellFrame
        return attr
    }
}

protocol ImagesViewDelegate {
    func sendImage(_ image: UIImage?)
}
