//
//  CustomNavigationControllerViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 17/12/21.
//

import UIKit

class CustomNavigationController: UINavigationController, UITextFieldDelegate {
    
    var customDelegate: CustomNavigationDelegate?
    
    let searchBarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .white
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.clearsOnBeginEditing = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.addSubview(searchBarView)
        searchBarView.addSubview(searchBar)
        searchBarView.addSubview(leftButton)
        self.setupNavigationController()
    }
    
    func setupNavigationController() {
        searchBarView.addSubview(searchBar)
        searchBarView.addSubview(leftButton)
        self.navigationBar.addSubview(searchBarView)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            searchBarView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, multiplier: 0.9),
            searchBarView.heightAnchor.constraint(equalTo: navigationBar.heightAnchor),
            searchBarView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            searchBarView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            leftButton.leftAnchor.constraint(equalTo: searchBarView.leftAnchor),
            leftButton.heightAnchor.constraint(equalTo: searchBarView.heightAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 50),
            searchBar.leftAnchor.constraint(equalTo: leftButton.rightAnchor),
            searchBar.rightAnchor.constraint(equalTo: searchBarView.rightAnchor),
            searchBar.heightAnchor.constraint(equalTo: searchBarView.heightAnchor),
            searchBar.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
        ])
        searchBar.delegate = self
        leftButton.addTarget(self, action: #selector(onLeftButtonClick), for: .touchUpInside)
    }
    
    @objc
    func onLeftButtonClick() {
        self.customDelegate?.onLeft()
        self.stopSearch()
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.stopSearch()
        self.customDelegate?.onSearch(query: searchBar.text)
        return true
    }

    func stopSearch() {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
}


protocol CustomNavigationDelegate {
    
    func goToSearch()
    func onSearch(query: String?)
    func onLeft()
}
