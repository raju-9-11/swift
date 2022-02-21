//
//  ImageSlideShow.swift
//  Shopz
//
//  Created by Rajkumar S on 30/01/22.
//

import UIKit


class ImageSlideShow: UIViewController, UIScrollViewDelegate {
    
    weak var delegate: ImageSlideShowDelegate?
    
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
        
        self.view.backgroundColor = UIColor.shopzBackGroundColor
        
        closeButton.addTarget(self, action: #selector(dismissFullscreenImage), for: .touchUpInside)
        
        zoomView.delegate = self
        imageView.frame = zoomView.frame
        
        zoomView.addSubview(imageView)
        view.addSubview(zoomView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @objc
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.delegate?.onHide(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

protocol ImageSlideShowDelegate: AnyObject {
    func onHide(_ imageSlideShow: ImageSlideShow)
}
