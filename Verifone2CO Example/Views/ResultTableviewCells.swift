//
//  ResultTableviewCells.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 09.01.2023.
//

import UIKit

// MARK: LogoAmountTableViewCell
class LogoAmountTableViewCell: UITableViewCell {
    var hStack: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var leftImageView: UIImageView! = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var rightTextLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium", size: 18.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var divider: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.AppColors.lineGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.hStack.addArrangedSubview(leftImageView)
        self.hStack.addArrangedSubview(rightTextLabel)
        self.contentView.addSubview(hStack)
        self.contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            divider.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            divider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            divider.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            leftImageView.widthAnchor.constraint(equalToConstant: 140.0),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

// MARK: TextWithDividerTableViewCell
class TextWithDividerTableViewCell: UITableViewCell {
    var hStack: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var titleTextLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium", size: 17.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var divider: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.AppColors.lineGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.hStack.addArrangedSubview(titleTextLabel)
        self.hStack.addArrangedSubview(divider)
        self.contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15.0)
        ])
    }
}

// MARK: LabelValueTableViewCell
class LabelValueTableViewCell: UITableViewCell {
    var hStack: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var leftTextLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium", size: 15.0)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var rightTextLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 15.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.hStack.addArrangedSubview(leftTextLabel)
        self.hStack.addArrangedSubview(rightTextLabel)
        self.contentView.addSubview(hStack)
        setConstraints()
    }
}

// MARK: ImageTableViewCell
class ImageTableViewCell: UITableViewCell {
    var appImageView: UIImageView! = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(appImageView)
        NSLayoutConstraint.activate([
            appImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            appImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            appImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            appImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: DesciptionTableViewCell
class DesciptionTableViewCell: UITableViewCell {
    var label: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    var textTopAnchor: NSLayoutConstraint?
    var textBottomAnchor: NSLayoutConstraint?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15)
        ])
        textTopAnchor = label.topAnchor.constraint(
            equalTo: self.contentView.topAnchor, constant: 10)
        textTopAnchor?.isActive = true
        textBottomAnchor = label.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor, constant: -10)
        textBottomAnchor?.isActive = true
    }
}

// MARK: ButtonTableViewCell
class ButtonTableViewCell: UITableViewCell {
    var button: UIButton! = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor.AppColors.blueColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var titleStr: String = "" {
        didSet {
            button.setTitle(titleStr, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
