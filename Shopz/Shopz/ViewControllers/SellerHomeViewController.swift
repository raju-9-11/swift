//
//  ViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 07/12/21.
//

import UIKit

class SellerHomeViewController: UIViewController {
    
    var sellerData: Seller? {
        willSet {
            if newValue != nil {
                self.loadData(with: newValue!)
                self.title = "\(newValue!.seller_name)'s Shop"
            }
        }
    }
    
    var pvc: ProductViewController?
    
    var elements: [SellerHomeElement] = []
    
    lazy var itemSize: CGSize = {
        let frame = CGSize(width: view.frame.width * 0.8, height: view.frame.width*0.8)
        var side: CGFloat = 100
        var excessWidth: CGFloat = frame.width.truncatingRemainder(dividingBy: side)
        while(excessWidth > 10) {
            side += 2
            excessWidth = frame.width.truncatingRemainder(dividingBy: side)
        }
        return CGSize(width: side, height: side)
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.register(SellerHomeTitleViewCell.self, forCellReuseIdentifier: SellerHomeTitleViewCell.cellID)
        tableView.register(SellerDescriptionCell.self, forCellReuseIdentifier: SellerDescriptionCell.cellID)
        tableView.register(SellerHomeBodyCell.self, forCellReuseIdentifier: SellerHomeBodyCell.cellID)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    deinit {
        pvc = nil
    }
    
    
    // MARK: - Layout and other functions
    func setupLayout() {
        view.backgroundColor = UIColor(named: "background_color")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func loadData(with seller: Seller) {
        elements = [
            TitleElement(title: seller.seller_name),
            SellerDescriptionElement(description: seller.description),
            BodyElement(products: StorageDB.getProducts(of: seller.seller_id))
        ]
        tableView.reloadData()
    }
    
    func displayProduct(product: Product) {
        pvc = nil
        pvc = ProductViewController()
        pvc!.productData = product
        self.navigationController?.pushViewController(pvc!, animated: true)
    }
    
}

extension SellerHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(elements[indexPath.row]) {
        case let item as TitleElement:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerHomeTitleViewCell.cellID, for: indexPath) as! SellerHomeTitleViewCell
            cell.title = item.title
            return cell
        case let item as SellerDescriptionElement:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerDescriptionCell.cellID, for: indexPath) as! SellerDescriptionCell
            cell.sellerDescription = item.description
            return cell
        case let item as BodyElement:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerHomeBodyCell.cellID, for: indexPath) as! SellerHomeBodyCell
            cell.itemSize = itemSize
            cell.delegate = self
            cell.productData = item.products
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerHomeBodyCell.cellID, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            let height = (itemSize.height + 5) * CGFloat(StorageDB.getProducts(of: sellerData?.seller_id ?? -1).count) + 10
            return height
        }
        return 100
    }
    
}

extension SellerHomeViewController: SellerHomeBodtCellDelegate {
    func onItemSelect(_ product: Product) {
        self.displayProduct(product: product)
    }
}

class SellerHomeElement {
    var id = UUID()
}

class TitleElement: SellerHomeElement {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

class SellerDescriptionElement: SellerHomeElement {
    var description: String
    
    init(description: String) {
        self.description = description
    }
}

class BodyElement: SellerHomeElement {
    var products: [Product]
    
    init(products: [Product]) {
        self.products = products
    }
}

