//
//  BoardCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 01/12/21.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "String"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var outerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 7
        return view
    }()
    
    var topIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "square.stack")
        imageView.tintColor = .black
        return imageView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "String"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var sprint: SprintsDataModel = SprintsDataModel(name: "TEST", description: "TEST") {
        willSet {
            self.logs = newValue.items.filter({ log in return log.boardType == self.boardType.type})
        }
    }
    
    var boardType: BoardTypeDataModel = BoardTypeDataModel(count: 0, color: .systemPink, type: .done) {
        willSet {
            outerContainer.backgroundColor = newValue.color.withAlphaComponent(0.2)
            titleLabel.text = newValue.type.rawValue
            countLabel.text = "\(newValue.count)"
        }
    }
    
    lazy var logs: [BacklogDataModel] = [BacklogDataModel(title: "Log 1", description: "Log init"), BacklogDataModel(title: "Log 2", description: "Log contined", startDate: Date(), endDate:Date(), type: .story, priority: .high)] {
        willSet {
            self.collectionView.reloadData()
            if newValue.isEmpty {
                setupEmptyLayout()
            } else {
                discardEmptyLayout()
            }
            
        }
    }
    
    let emptyView: BorderedView = {
        let bgView = BorderedView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView
    }()
    
    let topContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let cellID = "cellID"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BackLogCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        topContainer.addSubview(titleLabel)
        topContainer.addSubview(topIcon)
        topContainer.addSubview(countLabel)
        outerContainer.addSubview(topContainer)
        outerContainer.addSubview(collectionView)
        outerContainer.addSubview(emptyView)
        contentView.addSubview(outerContainer)
        self.setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BackLogCollectionViewCell
        cell.data = logs[indexPath.row]
        cell.size = collectionView.frame.size
        return cell
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            outerContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            outerContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            outerContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            outerContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95),
            collectionView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: outerContainer.widthAnchor, multiplier: 0.98),
            collectionView.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor),
            collectionView.heightAnchor.constraint(equalTo: outerContainer.heightAnchor, multiplier: 0.85),
            topContainer.topAnchor.constraint(equalTo: outerContainer.topAnchor),
            topContainer.widthAnchor.constraint(equalTo: outerContainer.widthAnchor),
            topContainer.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor),
            topContainer.heightAnchor.constraint(equalTo: outerContainer.heightAnchor, multiplier: 0.1),
            titleLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 15),
            countLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            countLabel.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -15),
            topIcon.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 10),
            topIcon.rightAnchor.constraint(equalTo: countLabel.leftAnchor, constant: -5),
        ])
    }
    
    func setupEmptyLayout() {
        contentView.addSubview(emptyView)
        emptyView.tintColor = outerContainer.backgroundColor?.withAlphaComponent(1) ?? UIColor.darkGray
        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalTo: outerContainer.widthAnchor, multiplier: 0.9),
            emptyView.centerXAnchor.constraint(equalTo: outerContainer.centerXAnchor),
            emptyView.heightAnchor.constraint(equalTo: outerContainer.heightAnchor, multiplier: 0.1),
            emptyView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
        ])
        emptyView.addEmptyLabel()
    }
    
    func discardEmptyLayout() {
        self.emptyView.removeFromSuperview()
    }
    
    
}

class BorderedView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addDashedBorder()
    }
    
    func addEmptyLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = self.tintColor
        label.text = "Drag and drop the item here"
        label.sizeToFit()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func addDashedBorder() {
        
        let color = self.tintColor.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

        self.layer.addSublayer(shapeLayer)
    }
}
