//
//  ViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 07/12/21.
//

import UIKit

class SellerHomeViewController: CustomViewController {
    
    var sellerData: Seller? {
        didSet {
            if sellerData != nil {
                self.loadData(with: sellerData!)
                self.title = sellerData!.seller_name
            }
        }
    }
    
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
        tableView.register(SellerHomeSearchCell.self, forCellReuseIdentifier: SellerHomeSearchCell.cellID)
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
    
    
    // MARK: - Layout and other functions
    override func setupLayout() {
        
        view.backgroundColor = UIColor.shopzBackGroundColor
        
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
            SellerSearchElement(placeholder: seller.seller_name),
            BodyElement(products: StorageDB.getProducts(of: seller.seller_id))
        ]
        tableView.reloadData()
    }
    
    func loadData(with seller: Seller, products: [Product]) {
        elements = [
            TitleElement(title: seller.seller_name),
            SellerDescriptionElement(description: seller.description),
            SellerSearchElement(placeholder: seller.seller_name),
            BodyElement(products: products)
        ]
        tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("TEST")
        self.view.endEditing(true)
    }
    
}

// MARK: - TableView Delegate
extension SellerHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return elements.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView != self.tableView {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
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
        case let item as SellerSearchElement:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerHomeSearchCell.cellID, for: indexPath) as! SellerHomeSearchCell
            cell.delegate = self
            cell.placeholder = item.placeholder
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerHomeBodyCell.cellID, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != self.tableView {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        if indexPath.row == 3 {
            let numberofItems = StorageDB.getProducts(of: sellerData?.seller_id ?? -1).count
            let height = (itemSize.height + 10) * CGFloat(max(numberofItems/3 + (numberofItems%3 > 0 ? 1 : 0), 1)) + 20
            return height
        }
        return 100
    }
    
    
}

extension SellerHomeViewController: SellerHomeBodtCellDelegate, SellerHomeSearchDelegate {
    
    func onItemSelect(_ product: Product) {
        self.displayProduct(product: product)
    }
    
    func onSearch(_ query: String) {
        guard let sellerData = sellerData else { return }
        let products: [Product] = StorageDB.getProducts(of: sellerData.seller_id).filter({ prod in return prod.product_name.lowercased().fuzzyMatch(query.lowercased()) })
        self.loadData(with: sellerData, products: products)
    }
    
    func onCancel() {
        guard let sellerData = sellerData else { return }
        self.loadData(with: sellerData)
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

class SellerSearchElement: SellerHomeElement {
    var placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
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

