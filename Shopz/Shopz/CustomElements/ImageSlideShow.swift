//
//  ImageSlideShow.swift
//  Shopz
//
//  Created by Rajkumar S on 30/01/22.
//

import UIKit


class ImageSlideShow: UIView, UIScrollViewDelegate {
    
    weak var delegate: ImageSlideShowDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var previousScale:CGFloat = 1.0
    
    var image: UIImage? {
        willSet {
            if newValue != nil {
                imageView.image = newValue
            }
        }
    }
    
    let imageView: UIImageView = {
        let newImageView = UIImageView()
        newImageView.backgroundColor = .clear
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        return newImageView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    let zoomView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = UIScreen.main.bounds
        scrollView.backgroundColor = .clear
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(named: "background_color")
        
        closeButton.addTarget(self, action: #selector(dismissFullscreenImage), for: .touchUpInside)
        
        zoomView.delegate = self
        imageView.frame = zoomView.frame
        
        zoomView.addSubview(imageView)
        self.addSubview(zoomView)
        self.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.delegate?.onHide(self)
        self.removeFromSuperview()
    }
    
    
}

protocol ImageSlideShowDelegate: AnyObject {
    func onHide(_ imageSlideShow: ImageSlideShow)
}
