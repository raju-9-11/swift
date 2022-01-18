//
//  Toast.swift
//  Shopz
//
//  Created by Rajkumar S on 18/01/22.
//

import UIKit


class Toast {
    
    static let shared: Toast = Toast()
    
    
    func showToast(message : String, type: ErrorType = .message, font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)) {
        
        if let view = UIApplication.shared.windows.first(where: { wind in wind.isKeyWindow }) {
            let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width*0.1 , y: view.frame.size.height-100, width:  view.frame.size.width*0.8, height: 35))
            toastLabel.backgroundColor = (type == .error ? UIColor.red : type == .message ? UIColor.black : UIColor.green).withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            view.addSubview(toastLabel)
            UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    enum ErrorType {
        case error, success, message
    }
}
