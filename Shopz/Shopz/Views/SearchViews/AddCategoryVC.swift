//
//  AddCategoryVC.swift
//  Shopz
//
//  Created by Rajkumar S on 28/01/22.
//

import Foundation
import UIKit


class AddCategoryVC: CustomViewController {
    
    var categories: [Category] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: AddCategoryDelegate?
    
    var selectedCategs: [IndexPath] = [] {
        willSet {
            addButton.isEnabled = !newValue.isEmpty
            addButton.backgroundColor = !newValue.isEmpty ? .red.withAlphaComponent(0.8) : .gray
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Category"
        label.font = .monospacedSystemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(named: "text_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        let title = "Add Categories"
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: 12, weight: .bold), range: NSRange(location: 0, length: title.count))
        button.isEnabled = false
        button.backgroundColor = .gray
        attrString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: title.count))
        button.setAttributedTitle(attrString as NSAttributedString, for: .normal)
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.backgroundColor = UIColor(named: "background_color")
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        cv.register(CategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: CategoryItemCollectionViewCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.isUserInteractionEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func setupLayout() {
        
        containerView.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(containerView)
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSearchBar)))
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            collectionView.heightAnchor.constraint(equalToConstant: min(CGFloat((categories.count/3)*50), view.frame.height*0.8)),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            backgroundView.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.9),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    @objc
    func onAdd() {
        delegate?.onAddCategs(self.selectedCategs.map({ return categories[$0.row] }))
        self.onDismiss()
    }
    
    @objc
    func onDismiss() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}


extension AddCategoryVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCategs.contains(indexPath) {
            selectedCategs.removeAll(where: { ipath in ipath.row == indexPath.row })
        } else {
            selectedCategs.append(indexPath)
        }
        collectionView.reloadData()
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCollectionViewCell.cellID, for: indexPath) as! CategoryItemCollectionViewCell
        cell.categoryData = categories[indexPath.row]
        cell.closeButton.isHidden = true
        if selectedCategs.contains(indexPath) {
            cell.customBackgroundView.backgroundColor = .red.withAlphaComponent(0.5)
        } else {
            cell.customBackgroundView.backgroundColor = .blue.withAlphaComponent(0.5)
        }
        cell.cellSize = CGSize(width: collectionView.frame.width - 2, height: collectionView.frame.height - 2)
        cell.delegate = self
        cell.layoutIfNeeded()
        return cell
    }
}

extension AddCategoryVC: CategoryItemDelegate {
    func removeCategory(category: Category) {
        for (index, val) in categories.enumerated() {
            if val.id == category.id {
                self.categories.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                return
            }
        }
    }
    
}

protocol AddCategoryDelegate: AnyObject {
    func onAddCategs(_ categories: [Category])
}
