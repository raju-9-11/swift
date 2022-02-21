//
//  RatingElement.swift
//  Shopz
//
//  Created by Rajkumar S on 31/01/22.
//

import UIKit

class RatingElement: UIView {
    
    weak var delegate: RatingElementDelegate?
    
    static let defHeight: CGFloat = 25
    
    var isEnabled: Bool = true {
        willSet {
            ratingButton.isHidden = !newValue
        }
    }
    
    var currentUserRating: Int = 1 {
        willSet {
            updateCurrentRating(rating: newValue)
        }
    }
    
    var elementTitle: String {
        get {
            return ratingButton.title(for: .normal) ?? ""
        }
        set {
            ratingButton.setTitle(newValue, for: .normal)
        }
    }
    
    let ratingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Rating", for: .normal)
        button.setTitleColor(.white, for: .normal)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            config.baseBackgroundColor = .blue.withAlphaComponent(0.8)
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            button.layer.cornerRadius = 6
            button.backgroundColor = .blue.withAlphaComponent(0.8)
        }
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingButton, starView])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let starView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    func setupLayout() {
        
        ratingButton.addInteraction(UIContextMenuInteraction(delegate: self))
        ratingButton.addTarget(self, action: #selector(onRatingClick), for: .touchUpInside)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])

        self.currentUserRating = 1
    }
    
    @objc
    func onRatingClick() {
        Toast.shared.showToast(message: "Press and hold to change rating")
    }
    
}

extension RatingElement: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
          identifier: nil,
          previewProvider: makeRatePreview) { _ in
            let rateMenu = self.makeRateMenu()
            let children = [rateMenu]
            return UIMenu(title: "", children: children)
        }
    }
    
    func makeRatePreview() -> UIViewController {
      let viewController = UIViewController()
      let imageView = UIImageView(image: UIImage(named: "rating_star"))
      viewController.view = imageView
      imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      viewController.preferredContentSize = imageView.frame.size
      
      return viewController
    }
    
    func makeRateMenu() -> UIMenu {
      let ratingButtonTitles = ["Worse", "Bad", "OK", "Good", "Fantastic"]
      
      let rateActions = ratingButtonTitles
        .enumerated()
        .map { index, title in
          return UIAction(title: title,
                          identifier: UIAction.Identifier("\(index + 1)"),
                          handler: updateRating)
        }
      
      return UIMenu(title: "Rate...",
                    image: UIImage(systemName: "star.circle"),
                    options: .displayInline,
                    children: rateActions)
    }
    private func updateCurrentRating(rating: Int) {
        UIView.animate(withDuration: 0.3) {
            if rating > 0 {
                self.ratingButton.setTitle("Update Rating", for: .normal)
                self.starView.isHidden = false
                
            } else {
                self.ratingButton.setTitle("Set Rating", for: .normal)
                self.starView.isHidden = true
            }
        }
        while starView.arrangedSubviews.count < rating {
            UIView.animate(withDuration: 1) {
                let imageView = UIImageView(image: UIImage(named: "rating_star"))
                imageView.contentMode = .scaleAspectFit
                self.starView.addArrangedSubview(imageView)
            }
        }
        while starView.arrangedSubviews.count > rating {
            UIView.animate(withDuration: 1) {
                self.starView.arrangedSubviews.first?.removeFromSuperview()
            }
        }
    }
    func updateRating(from action: UIAction) {
        guard let number = Int(action.identifier.rawValue) else {
            return
        }
        currentUserRating = number
    }
}

protocol RatingElementDelegate: AnyObject {
    
}
