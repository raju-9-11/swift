//
//  ProfileEditViewController.swift
//  Shopz
//
//  Created by Rajkumar S on 02/02/22.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    let maskView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(named: "background_color")?.withAlphaComponent(0.5)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDismiss)))
        view.addSubview(maskView)

        
    }
    
    @objc
    func onDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}
