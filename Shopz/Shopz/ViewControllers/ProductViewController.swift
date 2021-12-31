//
//  ProductViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class ProductViewController: CustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImagesViewDelegate, DescriptionCellDelegate {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(ProductDetailsTopCollectionViewCell.self, forCellWithReuseIdentifier: ProductDetailsTopCollectionViewCell.cellID)
        cv.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: DescriptionCollectionViewCell.cellID)
        cv.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: ReviewsCollectionViewCell.cellID)
        return cv
    }()
    
    let sellerVC = SellerHomeViewController()
    
    var productData = ItemData(name: "", media: "", cost: 0) {
        willSet {
            cells = [getImageData(with: newValue), getDescriptionData(with: newValue), getReviews(with: newValue)]
            collectionView.reloadData()
        }
    }
    
    var cells: [ProductDetailElement] = [
        ImagesViewElement(images: Array(repeating: UIImage(systemName: "photo.fill"), count: 5)),
        DescriptionElement(description: "The Grip-Rite #8 x 3 in. 16D Steel Bright Finish Duplex Nails (30 lb.-Pack) are perfect for framing, scaffolding and building temporary structures. These diamond point nails feature a smooth shank and double head design for easy nail removal.", title: "Steel Duplex", cost: 58, rating: 4.4, seller: SellerData(name: "Pacman", imageMedia: "")),
        ReviewElement(reviews: [
            Review(review: "Bad", owner: "moues"),
            Review(review: "Really bad", owner: "tom"),
            Review(review: "Worse", owner: "Pacman"),
            Review(review: "bad", owner: "Test"),
            Review(review: "Good", owner: "TEsting"),
            Review(review: "Bad", owner: "tesing"),
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = cells[indexPath.row] as? ImagesViewElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailsTopCollectionViewCell.cellID, for: indexPath) as! ProductDetailsTopCollectionViewCell
            cell.imageData = item
            cell.delegate = self
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: collectionView.frame.height*0.35)
            return cell
        }
        if let item = cells[indexPath.row] as? DescriptionElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.cellID, for: indexPath) as! DescriptionCollectionViewCell
            cell.data = item
            cell.delegate = self
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: collectionView.frame.height*0.45)
            return cell
        }
        
        if let item = cells[indexPath.row] as? ReviewElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.cellID, for: indexPath) as! ReviewsCollectionViewCell
            cell.reviewElementData = item
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCollectionViewCell.cellID, for: indexPath) as! DescriptionCollectionViewCell
        cell.cellFrame = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return cell
        
    }
    
    func getImageData(with itemData: ItemData) -> ImagesViewElement {
        return ImagesViewElement(images: Array(repeating: UIImage(systemName: "photo.fill"), count: 5))
    }
    
    func getDescriptionData(with itemData: ItemData) -> DescriptionElement {
        return DescriptionElement(description: "The Grip-Rite #8 x 3 in. 16D Steel Bright Finish Duplex Nails (30 lb.-Pack) are perfect for framing, scaffolding and building temporary structures. These diamond point nails feature a smooth shank and double head design for easy nail removal.", title: itemData.name, cost: 58, rating: 4.4, seller: SellerData(name: "Pacman", imageMedia: ""))
    }
    
    func displaySeller(sellerData: SellerData) {
        sellerVC.willMove(toParent: self)
        sellerVC.sellerData = sellerData
        self.addChild(sellerVC)
        self.view.addSubview(sellerVC.view)
    }
    
    
    func getReviews(with itemData: ItemData) -> ReviewElement {
        return ReviewElement(reviews: [
            Review(review: "Bad", owner: "moues"),
            Review(review: "Really bad", owner: "tom"),
            Review(review: "Worse", owner: "Pacman"),
            Review(review: "bad", owner: "Test"),
            Review(review: "Good", owner: "TEsting"),
            Review(review: "Bad", owner: "tesing"),
        ])
    }
    
    func sendImage(_ image: UIImage?) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @objc
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    override func setupLayout() {
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
        ])
    }

}

class ProductDetailElement {
    var id = UUID()
}

class ImagesViewElement: ProductDetailElement {
    var images: [UIImage?]
    
    init(images: [UIImage?]) {
        self.images = images
    }
}

class DescriptionElement: ProductDetailElement {
    var description: String
    var title: String
    var cost: Int
    var rating: Double
    var seller: SellerData
    
    init(description: String, title: String, cost: Int, rating: Double, seller: SellerData) {
        self.description = description
        self.title = title
        self.cost = cost
        self.rating = rating
        self.seller = seller
    }
}

class ReviewElement: ProductDetailElement {
    var reviews: [Review] = []
    
    init(reviews: [Review]) {
        self.reviews = reviews
    }
}

class Review {
    var review: String
    var owner: String
    var id = UUID()
    init(review: String, owner: String ) {
        self.review = review
        self.owner = owner
    }
}

class SellerData {
    var id = UUID()
    var name: String
    var imageMedia: String
    
    init(name: String, imageMedia: String) {
        self.name = name
        self.imageMedia = imageMedia
    }
}
