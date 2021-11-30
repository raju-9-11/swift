//
//  SprintsViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class SprintsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        cv.backgroundColor = .clear
        return cv
    }()
    
    var topLayerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var infoIcon: CustomInfoButton = {
        let leftIcon = CustomInfoButton(type: .infoDark)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.tintColor = .darkGray
        return leftIcon
    }()
    
    var dropDownIcon: DropDownButton = {
        let dropDownIcon = DropDownButton(type: .custom)
        dropDownIcon.translatesAutoresizingMaskIntoConstraints = false
        dropDownIcon.contentMode = .scaleAspectFit
        dropDownIcon.tintColor = .darkGray
        return dropDownIcon
    }()
    
    var dropDownContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        return containerView
    }()
    
    
    
    let cellID = "SprintsCellID"
    
    var items: [BacklogDataModel] = {
        return [BacklogDataModel(title: "Log 1", description: "Log init"), BacklogDataModel(title: "Log 2", description: "Log contined", startDate: Date(), endDate:Date(), type: .story, priority: .high)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        infoIcon.addAction(UIAction(handler: {
            _ in
            self.infoButtonTapped()
        }), for: .touchUpInside)
        
        dropDownIcon.addAction(UIAction(handler: {
            _ in
            self.dropDownTapped()
        }), for: .touchUpInside)
        
        topLayerContainerView.addSubview(infoIcon)
        topLayerContainerView.addSubview(dropDownIcon)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackLogCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        
        view.addSubview(topLayerContainerView)
        view.addSubview(collectionView)
        self.setupLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BackLogCollectionViewCell
        cell.data = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 15, height: 60)
    }
    
    func dropDownTapped() {
        if dropDownContainer.alpha == 0.5 {
            dismissDropDown()
        } else {
            showDropDown()
        }
    }
    
    func showDropDown() {
        dropDownContainer.alpha = 0.5
        dropDownContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDropDown)))
        if let vc = self.tabBarController?.navigationController {
            dropDownContainer.frame = vc.view.frame
            dropDownContainer.frame.origin.y = topLayerContainerView.frame.origin.y + topLayerContainerView.frame.height
            vc.view.addSubview(dropDownContainer)
        }
    }
    
    @objc
    func dismissDropDown() {
        self.dropDownContainer.alpha = 0
    }
    
    @objc
    func infoButtonTapped() {
        print("Info button tapped")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            topLayerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLayerContainerView.heightAnchor.constraint(equalToConstant: 40),
            topLayerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLayerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayerContainerView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoIcon.rightAnchor.constraint(equalTo: topLayerContainerView.rightAnchor, constant: -10),
            infoIcon.centerYAnchor.constraint(equalTo: topLayerContainerView.centerYAnchor),
            infoIcon.heightAnchor.constraint(equalTo: topLayerContainerView.heightAnchor, multiplier: 0.9),
            infoIcon.widthAnchor.constraint(equalTo: topLayerContainerView.heightAnchor, multiplier: 0.9),
            dropDownIcon.heightAnchor.constraint(equalTo: topLayerContainerView.heightAnchor, multiplier: 0.85),
            dropDownIcon.centerYAnchor.constraint(equalTo: topLayerContainerView.centerYAnchor),
            dropDownIcon.rightAnchor.constraint(equalTo: infoIcon.leftAnchor, constant: -10),
            dropDownIcon.leftAnchor.constraint(equalTo: topLayerContainerView.leftAnchor)
        ])
    }
    
}

class CustomInfoButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var isHighlighted: Bool {
        willSet {
            self.backgroundColor = newValue ? .systemGray3 : .clear
            self.tintColor = newValue ? .white : .darkGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 17
    }
}

class DropDownButton: UIButton {
    
    var customImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var customLabel: UILabel = {
        let label = UILabel()
        label.text = "String"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLabelName(_ name: String) {
        customLabel.text = name
    }
    
    func setCustomImage(_ image: UIImage) {
        customImageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(customImageView)
        self.addSubview(customLabel)
        self.setupLayouts()
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            customLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            customImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            customImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            customImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
        ])
    }
}

