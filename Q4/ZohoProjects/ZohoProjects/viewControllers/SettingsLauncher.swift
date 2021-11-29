//
//  File.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 28/11/21.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var containerView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellID = "myCell"
    
    let menuItems: [MenuItem] = {
        return [MenuItem(name: "Ungrouped Projects", icon: "barcode"), MenuItem(name: "Manage Projects", icon: "gear"), MenuItem(name: "Settings", icon: "gearshape.fill"), MenuItem(name: "Feedback", icon: "bubble.right.fill")]
    }()
    
    func showMenu() {
        
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            containerView.alpha = 0
            containerView.frame = keyWindow.frame
            keyWindow.addSubview(containerView)
            keyWindow.addSubview(collectionView)
            collectionView.frame = CGRect(x: -keyWindow.frame.width, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
            let gestureRecon = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
            containerView.addGestureRecognizer(gestureRecon)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.containerView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
            }, completion: nil)
        }
    }
    
    @objc
    func dismissMenu() {
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene})
            .first?.windows
            .filter({ $0.isKeyWindow}).first {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.collectionView.frame = CGRect(x: -keyWindow.frame.width, y: 0, width: keyWindow.frame.size.width*0.7, height: keyWindow.frame.size.height)
                self.containerView.alpha = 0
            }, completion: nil)
            
        }
    }
    
    override init() {
        super.init()
        collectionView.register(SideMenuCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SideMenuCollectionViewCell
        cell.itemString = menuItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
}

class MenuItem: NSObject {
    var name: String
    var icon: String
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}
