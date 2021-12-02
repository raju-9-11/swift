//
//  ReportsViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit

class ReportsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let velocityChartContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let burnDownChartContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let burnUpChartContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var charts: [UIView] = [velocityChartContainer, burnDownChartContainer, burnUpChartContainer]
    
    let chartscollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    let cellID = "cell1"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        chartscollectionView.delegate = self
        chartscollectionView.dataSource = self
        chartscollectionView.register(ReportsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        
        view.addSubview(chartscollectionView)
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReportsCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chartscollectionView.frame.width - 10, height: view.frame.height * 0.3)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            chartscollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartscollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chartscollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartscollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }

    

}
