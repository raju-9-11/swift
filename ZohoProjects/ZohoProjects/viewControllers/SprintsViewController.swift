//
//  SprintsViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class SprintsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var currSprint: SprintsDataModel = sprints[0]
    
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
    
    lazy var dropDownIconButton: DropDownButton = {
        let dropDownIcon = DropDownButton(type: .custom)
        dropDownIcon.setLabelName(sprints[0].name)
        dropDownIcon.translatesAutoresizingMaskIntoConstraints = false
        dropDownIcon.contentMode = .scaleAspectFit
        dropDownIcon.tintColor = .darkGray
        return dropDownIcon
    }()
    
    var dropDownContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        containerView.alpha = 0
        return containerView
    }()
    
    var dropDownSubContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var dropDownCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var searchBar: Search = {
        let bar = Search()
        bar.placeholder = "Search sprints"
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var sprints: [SprintsDataModel] = {
        return [SprintsDataModel(name: "Sprint1", description: "sprint description", items: [BacklogDataModel(title: "Log 1", description: "Log init")]), SprintsDataModel(name: "Sprint2", description: "Sprint successor description ", owner: "pacman", sprintsUser: ["user1, user2"], startDate: Date(), endDate: Date(), items: [BacklogDataModel(title: "Log 1", description: "Log init"), BacklogDataModel(title: "Log 2", description: "Log contined", startDate: Date(), endDate:Date(), type: .story, priority: .high)]) ]
    }()
    
    let cellID = "SprintsCellID"
    let dropDownCellID = "DropDownCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        infoIcon.addAction(UIAction(handler: {
            _ in
            self.infoButtonTapped()
        }), for: .touchUpInside)
        
        dropDownIconButton.addAction(UIAction(handler: {
            _ in
            self.dropDownTapped()
        }), for: .touchUpInside)
        
        dropDownContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDropDown)))
        
        topLayerContainerView.addSubview(infoIcon)
        topLayerContainerView.addSubview(dropDownIconButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackLogCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        
        view.addSubview(topLayerContainerView)
        view.addSubview(collectionView)
        self.setupLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dropDownCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dropDownCellID, for: indexPath) as! DropDownCollectionViewCell   
            cell.sprint = sprints[indexPath.row]
            if currSprint.name == sprints[indexPath.row].name {
                cell.isCustomSelected = true
            } else {
                cell.isCustomSelected = false
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BackLogCollectionViewCell
        cell.data = currSprint.items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dropDownCollectionView {
            return sprints.count
        }
        return currSprint.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dropDownCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        return CGSize(width: collectionView.frame.size.width - 15, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dropDownCollectionView {
            self.currSprint = sprints[indexPath.row]
            self.dropDownIconButton.setLabelName(currSprint.name)
            collectionView.reloadData()
            self.collectionView.reloadData()
            self.dismissDropDown()
        }
    }
    
    func dropDownTapped() {
        if dropDownContainer.alpha == 0.5 {
            self.dismissDropDown()
        } else {
            self.showDropDown()
        }
    }
    
    func showDropDown() {
        if let vc = self.tabBarController?.navigationController {
            self.dropDownContainer.frame = vc.view.frame
            self.dropDownContainer.frame.origin.y = self.topLayerContainerView.frame.origin.y + self.topLayerContainerView.frame.height
            self.setupDropDownContainer()
            vc.view.addSubview(dropDownContainer)
            vc.view.addSubview(dropDownSubContainer)
            searchBar.becomeFirstResponder()
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
                self.dropDownContainer.alpha = 0.5
                self.dropDownSubContainer.frame.origin.x = 0
            }, completion: nil)
        }
    }
    
    func setupDropDownContainer() {
        dropDownCollectionView.delegate = self
        dropDownCollectionView.dataSource = self
        dropDownCollectionView.register(DropDownCollectionViewCell.self, forCellWithReuseIdentifier: dropDownCellID)
        dropDownSubContainer.addSubview(dropDownCollectionView)
        dropDownSubContainer.frame = dropDownContainer.frame
        dropDownSubContainer.frame.size.height = 50 + 50 * CGFloat(sprints.count)
        dropDownSubContainer.frame.origin.x = dropDownSubContainer.frame.width
        dropDownSubContainer.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: dropDownSubContainer.topAnchor),
            searchBar.widthAnchor.constraint(equalTo: dropDownSubContainer.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            searchBar.centerXAnchor.constraint(equalTo: dropDownSubContainer.centerXAnchor),
            dropDownCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            dropDownCollectionView.widthAnchor.constraint(equalTo: dropDownSubContainer.widthAnchor),
            dropDownCollectionView.centerXAnchor.constraint(equalTo: dropDownSubContainer.centerXAnchor),
            dropDownCollectionView.heightAnchor.constraint(equalToConstant: 50 * CGFloat(sprints.count)),
        ])
        
    }
    
    @objc
    func dismissDropDown() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.dropDownContainer.alpha = 0
            self.dropDownSubContainer.frame.origin.x = self.dropDownSubContainer.frame.width
        }, completion: {
            _ in
            self.dropDownSubContainer.removeFromSuperview()
            self.dropDownContainer.removeFromSuperview()
        })
        searchBar.resignFirstResponder()
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
            dropDownIconButton.heightAnchor.constraint(equalTo: topLayerContainerView.heightAnchor, multiplier: 0.85),
            dropDownIconButton.centerYAnchor.constraint(equalTo: topLayerContainerView.centerYAnchor),
            dropDownIconButton.rightAnchor.constraint(equalTo: infoIcon.leftAnchor, constant: -10),
            dropDownIconButton.leftAnchor.constraint(equalTo: topLayerContainerView.leftAnchor)
        ])
    }
    
}

class SprintsDataModel {
    var name: String
    var description: String
    var owner: String
    var sprintsUser: [String]
    var startDate: Date?
    var endDate: Date?
    var items: [BacklogDataModel]
    
    init(name: String, description: String, owner: String = "Pacman", sprintsUser: [String], startDate: Date, endDate: Date, items: [BacklogDataModel] = [] ) {
        self.name = name
        self.description = description
        self.owner = owner
        self.sprintsUser = sprintsUser
        self.startDate = startDate
        self.endDate = endDate
        self.items = items
    }
    
    init(name: String, description: String, owner: String = "Pacman", items: [BacklogDataModel] = []) {
        self.name = name
        self.description = description
        self.owner = owner
        self.sprintsUser = []
        self.startDate = nil
        self.endDate = nil
        self.items = items
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
        label.font = .systemFont(ofSize: 15, weight: .semibold)
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

