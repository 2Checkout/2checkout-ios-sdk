//
//  SegmentedControlTableViewCell.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 26.05.2023.
//

import UIKit

class SegmentedControlTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var segmentedControlSecurityEntry: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["None", "PartialHide", "Hidden"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(segmentedControlSecurityEntry)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),

            segmentedControlSecurityEntry.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            segmentedControlSecurityEntry.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            segmentedControlSecurityEntry.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        ])
    }
}
