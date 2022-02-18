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
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search"
        search.searchBarStyle = .minimal
        search.isTranslucent = false
        search.barTintColor = UIColor(named: "background_color")
        return search
    }()
    
    var searchBarConstraint: NSLayoutConstraint?

    func setupLayout() {
        
        searchBar.delegate = self
        
        contentView.addSubview(searchBar)
        contentView.addSubview(cancelButton)
        searchBarConstraint = cancelButton.isHidden ? searchBar.rightAnchor.constraint(equalTo: cancelButton.rightAnchor) : searchBar.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: 5)

        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            searchBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cancelButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            
        ])
        searchBarConstraint?.isActive = true
        
        cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.removeViews()
    }
    
    @objc
    func onCancelClick() {
        delegate?.onCancel()
        cancelButton.isHidden = true
        searchBar.resignFirstResponder()
        searchBarConstraint?.isActive = false
        searchBarConstraint = searchBar.rightAnchor.constraint(equalTo: cancelButton.rightAnchor)
        searchBarConstraint?.isActive = true
    }
}

extension SellerHomeSearchCell: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        cancelButton.isHidden = false
        searchBarConstraint?.isActive = false
        searchBarConstraint = self.searchBar.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: 5)
        searchBarConstraint?.isActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.onSearch(text)
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
    }
}


protocol SellerHomeSearchDelegate: AnyObject {
    func onSearch(_ query: String)
    func onCancel()
}
