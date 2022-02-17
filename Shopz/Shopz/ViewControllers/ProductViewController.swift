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
        cv.register(ProductDetailsTopCollectionViewCell.self, forCellWithReuseIdentifier: ProductDetailsTopCollectionViewCell.cellID)
        cv.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: DescriptionCollectionViewCell.cellID)
        cv.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: ReviewsCollectionViewCell.cellID)
        cv.register(AddReviewCollectionViewCell.self, forCellWithReuseIdentifier: AddReviewCollectionViewCell.cellID)
        cv.backgroundColor = .clear
        return cv
    }()
    
    var myReview: Review?
    
    var sellerVC: SellerHomeViewController?
    
    var productData: Product? {
        willSet {
            if newValue != nil {
                self.title = "\(newValue!.product_name)"
                self.loadData(with: newValue!)
            }
        }
    }
    
    var cells: [ProductDetailElement] = []
    
    var reviewImages: [UIImage] = []
    
    var cvc: CheckoutViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
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
        self.collectionView.layoutIfNeeded()
    }
    
    func loadData(with product: Product) {
        myReview = ApplicationDB.shared.hasReviewed(product: product)
        cells = [
            ImagesViewElement(images: product.image_media),
            DescriptionElement(description: product.description, title: product.product_name, cost: product.price, rating: product.rating, seller: StorageDB.getSellerData(of: product.seller_id)),
            ReviewElement(reviews: ApplicationDB.shared.getReviews(product: product))
        ]
        if Auth.auth != nil && ApplicationDB.shared.userHasPurchased(product: product) {
            cells.insert(AddReviewElement(), at: 2)
        }
        self.collectionView.reloadData()
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
            cell.delegate = self
            cell.data = item
            let textviewHeight = item.title.height(withConstrainedWidth: view.frame.width*0.7, font: .italicSystemFont(ofSize: 13))
            let titleLabelHeight = item.description.height(withConstrainedWidth: view.frame.width*0.7, font: .systemFont(ofSize: 15, weight: .semibold))
            let frameHeight = textviewHeight + titleLabelHeight + 150
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: max(200, frameHeight))
            return cell
        }
        
        if let _ = cells[indexPath.row] as? AddReviewElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddReviewCollectionViewCell.cellID, for: indexPath) as! AddReviewCollectionViewCell
            cell.delegate = self
            cell.review = myReview
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: 100)
            return cell
        }
        
        if let item = cells[indexPath.row] as? ReviewElement {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewsCollectionViewCell.cellID, for: indexPath) as! ReviewsCollectionViewCell
            let list: [CGFloat] = item.reviews.map({ review in
                let textviewHeight = review.review.height(withConstrainedWidth: collectionView.frame.width*0.63, font: .systemFont(ofSize: 12, weight: .semibold))
                if !ApplicationDB.shared.getReviewMediaList(review: review).isEmpty {
                    return textviewHeight + 220
                }
                return textviewHeight
            })
            cell.reviewElementData = item
            cell.cellFrame = CGSize(width: collectionView.frame.width, height: list.reduce(0, +))
            cell.reviewListCellHeight = list
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

extension ProductViewController: ReviewElementDelegate, ImagesViewDelegate, DescriptionCellDelegate {
    
    func addReview(review: String, rating: Int, media: [ApplicationDB.ReviewMedia]) {
        if let productData = productData {
            ApplicationDB.shared.addReview(review: review, rating: rating, productID: productData.product_id, media: media)
            self.loadData(with: productData)
        }
    }
    
    func editReview(oldReview: Review, rating: Int, review: String, media: [ApplicationDB.ReviewMedia]) {
        ApplicationDB.shared.editReview(oldReview: oldReview, rating: rating, review: review, media: media)
        guard let productData = productData else { return }
        loadData(with: productData)
    }
    
    func deleteReview(_ review: Review) {
        ApplicationDB.shared.deleteReview(review: review)
        guard let productData = productData else { return }
        loadData(with: productData)
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
    
    func addImageClicked(sender: UIView, delegateSource: AddReviewCollectionViewCell) {
        var imagePicker = UIImagePickerController()
        let alert = UIAlertController(title: "Add Image", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = ["public.movie", "public.image"]
                imagePicker.modalPresentationStyle = .overFullScreen
                imagePicker.delegate = delegateSource
                self.present(imagePicker, animated: true)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { _ in
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.delegate = delegateSource
            self.present(imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.delegate = delegateSource
            self.present(imagePicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }
        present(alert, animated: true, completion: nil)
    }
    
    func imagesChanged(_ hasImages: Bool) {
        self.collectionView.collectionViewLayout.invalidateLayout()
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
        present(imageView, animated: true, completion: nil)
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
