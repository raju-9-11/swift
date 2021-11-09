//
//  CustomTableViewCell.swift
//  Quest6
//
//  Created by Rajkumar S on 03/11/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var row: UIStackView!
    
    var view1 = Container()
    var view2 = Container()
    var view3 = Container()
    var view4 = Container()
    
    var data: DataModel! {
        didSet {
            view1.label.text = data.country
            let day = localDay(in: data.timeZone,dateFormat: data.formats.dateFormat, date: data.date)
            view2.label.text = day["day"]
            view3.label.text = localTime(in: data.timeZone, hour24: data.formats.hour24, timeFormat: data.formats.timeFormat, date: data.date)
            view4.label.text = day["date"]
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        row = newRow(elements: [view1.containerView, view2.containerView, view3.containerView, view4.containerView], spacing: 10, axis: .horizontal, distribution: .fillEqually, alignment: .center)

        self.contentView.addSubview(row)
        self.setUpLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpLayout() {
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            row.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, constant: -20),
            row.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    
    func newRow(elements: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: elements)
        stackView.axis = axis
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        return stackView
    }
}
