//
//  FeedViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let items : [FeedItem] = {
        return [FeedItem(owner: "Pacman", pic: "person.fill", process: "Created", result: "Project", time: "25 Nov 12: 45 PM")]
    }()
    
    let cellID = "FeedCell"
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        view.addSubview(collectionView)
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCollectionViewCell
        cell.item = items[indexPath.row]
        cell.size = collectionView.frame.size
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


}


class FeedItem: NSObject {
    
    var owner: String
    var pic: String
    var process: String
    var result: String
    var time: String
    
    init(owner: String, pic: String, process: String, result: String, time: String) {
        self.owner = owner
        self.pic = pic
        self.process = process
        self.result = result
        self.time = time
    }
}
