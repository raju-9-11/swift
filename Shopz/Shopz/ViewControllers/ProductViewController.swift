//
//  ProductViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 20/12/21.
//

import UIKit

class ProductViewController: CustomViewController {
    
    var bottomConstraint: NSLayoutConstraint?
    
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
        cv.register(AddReviewCollectionViewCell.self, forCellWithReuseIdentifier: AddReviewCollectionViewCell.cellID)
        cv.backgroundColor = .clear
        return cv
    }()
    
    var sellerVC: SellerHomeViewController?
    
    var productData: Product? {
        willSet {
            if newValue != nil {
                self.loadData(with: newValue!)
            }
        }
    }
    
    var cells: [ProductDetailElement] = []
    
    var cvc: CheckoutViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.layoutSubviews()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    deinit {
        cvc = nil
        sellerVC = nil
    }
    
    override func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        bottomConstraint?.isActive = true
    }
    
    func loadData(with product: Product) {
        cells = [
            ImagesViewElement(images: product.image_media),
            DescriptionElement(description: product.description, title: product.product_name, cost: product.price, rating: product.rating, seller: StorageDB.getSellerData(of: product.seller_id)),
            ReviewElement(reviews: ApplicationDB.shared.getReviews(product: product))
        ]
        if ApplicationDB.shared.userHasPurchased(product: product) {
            cells.insert(AddReviewElement(), at: 2)
        }
        collectionView.reloadData()
    }
    

}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: 100)
            cell.layoutIfNeeded()
            collectionView.layoutSubviews()
            return cell
        }
        
        if let _ = cells[indexPath.row] as? AddReviewElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddReviewCollectionViewCell.cellID, for: indexPath) as! AddReviewCollectionViewCell
            cell.delegate = self
            cell.setupLayout()
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: 100)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension ProductViewController: ReviewElementDelegate, ImagesViewDelegate, DescriptionCellDelegate, ImageSlideShowDelegate {
    
    func addReview(review: String, rating: Int) {
        if let productData = productData {
            ApplicationDB.shared.addReview(review: review, rating: rating, productID: productData.product_id)
            self.loadData(with: productData)
        }
    }
    
    func reviewBeginEditing(frame: CGRect?) {
        bottomConstraint?.constant = -1 * ((frame?.height ?? 0) - (self.tabBarController?.tabBar.frame.height ?? 0))
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .bottom, animated: true)
        }
    }
    func reviewDidEndEditing() {
        bottomConstraint?.constant = 0
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .bottom, animated: true)
        }
    }
    
    func displaySeller(sellerData: Seller) {
        sellerVC = nil
        sellerVC = SellerHomeViewController()
        sellerVC?.sellerData = sellerData
        self.navigationController?.pushViewController(sellerVC!, animated: true)
    }
    
    func buyClicked() {
        cvc = nil
        cvc = CheckoutViewController()
        if productData != nil {
            cvc?.bind(with: productData!)
        }
        self.navigationController?.pushViewController(cvc!, animated: true)
    }
    
    func addToCartClicked() {
        if let productData = productData {
            ApplicationDB.shared.addToCart(item: productData)
        }
    }
    
    func addToShoppingList(list: ShoppingList) {
        if let productData = productData {
            ApplicationDB.shared.addToShoppingList(item: productData, list: list)
        }
    }
    
    func displayImage(_ image: UIImage?) {
        let imageView = ImageSlideShow()
        imageView.image = image
        imageView.delegate = self
        self.view.addSubview(imageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func onHide(_ imageSlideShow: ImageSlideShow) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
}

class ProductDetailElement {
    var id = UUID()
}

class ImagesViewElement: ProductDetailElement {
    var images: [String]
    
    init(images: [String]) {
        self.images = images
    }
}

class DescriptionElement: ProductDetailElement {
    var description: String
    var title: String
    var cost: Decimal
    var rating: Decimal
    var seller: Seller?
    
    init(description: String, title: String, cost: Decimal, rating: Decimal, seller: Seller?) {
        self.description = description
        self.title = title
        self.cost = cost
        self.rating = rating
        self.seller = seller
    }
}

class AddReviewElement: ProductDetailElement {
    
}

class ReviewElement: ProductDetailElement {
    var reviews: [Review] = []
    
    init(reviews: [Review]) {
        self.reviews = reviews
    }
}
