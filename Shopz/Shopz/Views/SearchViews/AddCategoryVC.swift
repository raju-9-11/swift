//
//  AddCategoryVC.swift
//  Shopz
//
//  Created by Rajkumar S on 28/01/22.
//

import Foundation
import UIKit


class AddCategoryVC: UIViewController {
    
    var categories: [Category] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: AddCategoryDelegate?
    
    var selectedCategs: [IndexPath] = [] {
        willSet {
            addButton.isEnabled = !newValue.isEmpty
            if #available(iOS 15.0, *) {
                addButton.configuration?.baseBackgroundColor = !newValue.isEmpty ? .systemBlue.withAlphaComponent(0.8) : .gray
            } else {
                addButton.backgroundColor = !newValue.isEmpty ? .systemBlue.withAlphaComponent(0.8) : .gray
            }
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
        let title = "Add Categories"
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        button.layer.cornerRadius = 6
        let attrString = NSMutableAttributedString(string: title)
        button.isEnabled = false
        button.backgroundColor = .gray
        attrString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: title.count))
        button.setAttributedTitle(attrString as NSAttributedString, for: .normal)
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
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
        let layout = LeftAlignedCollectionViewFlowLayout()
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
    
    let cancel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = "Cancel"
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        let attrString = NSMutableAttributedString(string: title)
        button.backgroundColor = .red
        button.layer.cornerRadius = 6
        attrString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: title.count))
        button.setAttributedTitle(attrString as NSAttributedString, for: .normal)
        return button
    }()
    
    lazy var buttonsView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancel, addButton])
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(containerView)
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(titleLabel)
        view.addSubview(buttonsView)
        
        addButton.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(onDismiss), for: .touchUpInside)
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        
        NSLayoutConstraint.activate([
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
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            buttonsView.heightAnchor.constraint(equalToConstant: 30),
            buttonsView.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.9)
            
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
        self.dismiss(animated: true, completion: nil)
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

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
