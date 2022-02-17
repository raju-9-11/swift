//
//  SellerHomeSearchCell.swift
//  Shopz
//
//  Created by Rajkumar S on 17/02/22.
//

import Foundation
import UIKit

class SellerHomeSearchCell: UITableViewCell {
    
    static let cellID = "SELLERHOMESeakrchcellid"
    
    weak var delegate: SellerHomeSearchDelegate?
    
    var placeholder: String = "" {
        willSet {
            searchBar.placeholder = "Search \(newValue)'s Shop"
            self.setupLayout()
        }
    }
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search"
        search.searchBarStyle = .minimal
        search.isTranslucent = false
        search.barTintColor = UIColor(named: "background_color")
        return search
    }()
    
    func setupLayout() {
        
        searchBar.delegate = self
        
        contentView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
}

extension SellerHomeSearchCell: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
}


protocol SellerHomeSearchDelegate: AnyObject {
    
}
