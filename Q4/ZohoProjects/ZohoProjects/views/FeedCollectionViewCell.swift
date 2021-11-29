//
//  FeedCollectionViewCell.swift
//  ZohoProjects
//
//  Created by Rajkumar S on 29/11/21.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        return label
    }()
    
    var size: CGSize = .zero
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .darkGray
        label.text = "25 Nov 12:35 AM"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .center
        return label
    }()
    
    var addCommentView: UIView = {
        let view = ViewWithTopBorder()
        let textField = TextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add Comment"
        textField.backgroundColor = .systemGray5
        textField.isEnabled = false
        textField.layer.cornerRadius = 6
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 12, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        let line = UIView()
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        return view
    }()
    
    var profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.filled")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var item: FeedItem = FeedItem(owner: "PACMAN", pic: "person", process: "Unknown", result: "Test", time: "Nov 25 12: 45 PM"){
        willSet {
            let attr: NSMutableAttributedString = NSMutableAttributedString(string: newValue.owner)
            attr.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)], range: NSRange(location: 0, length: newValue.owner.count))
            attr.append(NSAttributedString(string: " \(newValue.process) \(newValue.result)"))
            titleLabel.attributedText = attr
            profileView.image = UIImage(systemName: newValue.pic)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        
        addCommentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCommentTapped)))
        self.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(profileView)
        contentView.addSubview(addCommentView)
        self.layer.cornerRadius = 8
        self.setupLayout()
    }
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            profileView.heightAnchor.constraint(equalToConstant: 34),
            profileView.widthAnchor.constraint(equalToConstant: 34),
            profileView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            timeLabel.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: 10),
            
            addCommentView.heightAnchor.constraint(equalToConstant: 50),
            addCommentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            addCommentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addCommentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        profileView.layer.cornerRadius = 17
    }
    
    @objc
    func addCommentTapped() {
        print("Adding comment....")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attr = layoutAttributes
        attr.size.width = self.size.width - 15
        attr.size.height = 150
        return attr
    }
    
}


class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class ViewWithTopBorder: UIView {
    
    var myPath: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.backgroundColor = UIColor.clear
    }
       
    override func draw(_ rect: CGRect) {
        drawLine()
        UIColor.systemGray3.setStroke()
        myPath.stroke()
    }
      
      
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
      
      
    func drawLine(){
        myPath = UIBezierPath()
        myPath.lineWidth = 1
        myPath.move(to: CGPoint(x: 0.0 , y: 0 ))
        myPath.addLine(to: CGPoint(x: self.frame.width, y: 0))
          
    }

}
