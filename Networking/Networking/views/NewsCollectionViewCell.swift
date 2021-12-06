//
//  NewsCollectionViewCell.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    var article: Article? = nil {
        willSet {
            self.updateLayout()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.sizeToFit()
        return label
    }()
    
    let summaryView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 11, weight: .light)
        textView.isSelectable = false
        textView.text = "Summary"
        textView.textColor = .gray
        return textView
    }()
    
    let subContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints =  false
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subContainerView.layer.cornerRadius = 6
        self.subContainerView.clipsToBounds = true
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.shadowOpacity = 1
        var shadowFrame = self.contentView.bounds
        self.contentView.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contentView.layer.shadowRadius = 5
        
        
        subContainerView.addSubview(imageView)
        subContainerView.addSubview(titleLabel)
        subContainerView.addSubview(summaryView)
        contentView.addSubview(subContainerView)
        self.setupLayout()
    }
    
    func updateLayout() {
        downloadImage(from: URL(string: article?.media ?? "https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg")!)
        titleLabel.text = article?.title ?? "Title"
        summaryView.text = article?.summary ?? "Summary"
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            subContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            subContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            subContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerXAnchor.constraint(equalTo: subContainerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: subContainerView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: subContainerView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: subContainerView.heightAnchor, multiplier: 0.6),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo: subContainerView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: subContainerView.rightAnchor, constant: -10),
            summaryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            summaryView.leftAnchor.constraint(equalTo: subContainerView.leftAnchor, constant: 10),
            summaryView.rightAnchor.constraint(equalTo: subContainerView.rightAnchor, constant: -10),
            summaryView.bottomAnchor.constraint(equalTo: subContainerView.bottomAnchor, constant: -5)
        ])
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
