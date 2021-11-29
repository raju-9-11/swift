//
//  CustomFeedTitle.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit

class CustomFeedTitle: UIBarButtonItem {
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedSystemFont(ofSize: 15, weight: .heavy)
        return label
    }()
    
    var projectTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .monospacedSystemFont(ofSize: 11, weight: .medium)
        label.text = "project"
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init() {
        super.init()
        
        containerView.addSubview(mainTitle)
        containerView.addSubview(projectTitle)
        self.customView = containerView
        self.setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            self.mainTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            self.projectTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 2),
            self.containerView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setProjectTitle(name: String) {
        self.projectTitle.text = name
    }
    
    func setMainTitle(name: String) {
        self.mainTitle.text = name
    }

}
