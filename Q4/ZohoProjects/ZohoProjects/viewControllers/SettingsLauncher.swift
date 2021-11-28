//
//  File.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 28/11/21.
//

import UIKit

class SettingsLauncher: NSObject {
    
    var containerView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func showSettings() {
        
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
}
