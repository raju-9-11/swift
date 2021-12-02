//
//  BoardViewController.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 25/11/21.
//

import UIKit

class BoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var currSprint: SprintsDataModel = sprints[0]
    
    
    var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    var sprints: [SprintsDataModel] = {
        return [SprintsDataModel(name: "Sprint1", description: "sprint description", items: [BacklogDataModel(title: "Log 1", description: "Log init")]), SprintsDataModel(name: "Sprint2", description: "Sprint successor description ", owner: "pacman", sprintsUser: ["user1, user2"], startDate: Date(), endDate: Date(), items: [BacklogDataModel(title: "Log 1", description: "Log init"), BacklogDataModel(title: "Log 2", description: "Log contined", startDate: Date(), endDate:Date(), type: .story, priority: .high)]) ]
    }()
    
    
    var topLevelContainerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .black
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
    
    
    let types: [BoardTypeDataModel] = {
        return [BoardTypeDataModel(count: 0, color: .systemPink, type: .todo), BoardTypeDataModel(count: 0, color: .darkGray, type: .inprogress), BoardTypeDataModel(count: 0, color: .cyan, type: .done)]
    }()
    
    let cellID = "SprintsCellID"
    let dropDownCellID = "DropDownCellID"
    let typeCollectionCellID = "TypeCollectionCellID"

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
        
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        typeCollectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: typeCollectionCellID)
        
        view.addSubview(typeCollectionView)
        view.addSubview(topLayerContainerView)
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
        if collectionView == typeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: typeCollectionCellID, for: indexPath) as! BoardCollectionViewCell
            cell.boardType = types[indexPath.row]
            cell.sprint = currSprint
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
        if collectionView == typeCollectionView {
            return types.count
        }
        return currSprint.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dropDownCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        if collectionView == typeCollectionView {
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height - 20)
        }
        return CGSize(width: collectionView.frame.size.width - 15, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dropDownCollectionView {
            self.currSprint = sprints[indexPath.row]
            self.dropDownIconButton.setLabelName(currSprint.name)
            collectionView.reloadData()
            self.typeCollectionView.reloadData()
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
            searchBar.becomeFirstResponder()
            self.dropDownContainer.frame = vc.view.frame
            self.dropDownContainer.frame.origin.y = self.topLayerContainerView.frame.origin.y + self.topLayerContainerView.frame.height
            self.setupDropDownContainer()
            vc.view.addSubview(dropDownContainer)
            vc.view.addSubview(dropDownSubContainer)
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
            typeCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            typeCollectionView.topAnchor.constraint(equalTo: topLayerContainerView.bottomAnchor),
            typeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            typeCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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


class BoardTypeDataModel {
    var count: Int
    var color: UIColor
    var type: BoardType
    
    init(count: Int, color: UIColor, type: BoardType = .todo) {
        self.count = count
        self.color = color
        self.type = type
    }
}

enum BoardType: String {
    case todo = "To Do", inprogress = "In Progress", done = "Done"
}
