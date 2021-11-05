//
//  CustomTableViewCell.swift
//  Quest6
//
//  Created by Rajkumar S on 03/11/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var row: UIStackView!
    
    var view1: Container = {
        let view = Container()
        return view
    }()
    
    var view2: Container = {
        let view = Container()
        return view
    }()
    
    var view3: Container = {
        let view = Container()
        return view
    }()
    
    var data: DataModel! {
        didSet {
            view1.label.text = data.country
            view2.label.text = data.time
            view3.label.text = data.timeZone
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        row = newRow(elements: [view1.containerView, view2.containerView], spacing: 0, axis: .horizontal, distribution: .fillEqually, alignment: .center)
        self.contentView.addSubview(row)
        self.setUpLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpLayout() {
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            row.widthAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            row.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    
    func newRow(elements: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: elements)
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
