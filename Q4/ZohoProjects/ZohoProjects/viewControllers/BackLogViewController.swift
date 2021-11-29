//
//  BackLogViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class BackLogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var items: [BacklogDataModel] = {
        return [BacklogDataModel(title: "Log 1", description: "Log init"), BacklogDataModel(title: "Log 2", description: "Log contined", startDate: Date(), endDate:Date(), type: .story, priority: .high)]
    }()
    
    let cellID: String = "backLogCell"
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemGray6
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackLogCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collectionView)
        self.setupLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BackLogCollectionViewCell
        cell.size = collectionView.frame.size
        cell.data = items[indexPath.row]
        return cell
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
    
    func onSearch() {
        print("SearchTapped")
    }
    
    func onFilter() {
        print("FilterTapped")
    }

}

class BacklogDataModel {
    var title: String
    var description: String?
    var startDate: Date?
    var endDate: Date?
    var type: BacklogType
    var priority: Priority
    var index: Int
    static var index: Int = 0
    
    init(title: String, description: String, startDate: Date? = nil, endDate: Date? = nil, type: BacklogType = .story, priority: Priority = .none) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.priority = priority
        self.index = BacklogDataModel.index
        BacklogDataModel.index += 1
    }
    
}

enum BacklogType: String {
    case story = "Story", task = "Task", bug = "Bug"
}

enum Priority {
    case none, high, medium, low
}
