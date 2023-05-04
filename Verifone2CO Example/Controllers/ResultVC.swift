//
//  ResultVC.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 10.01.2023.
//

import UIKit

struct ResultSection {
    var header: String
    var cells: [ResultCellData]
}

struct ResultCellData {
    var type: CellType
    var placeholder: String
    var value: String
}

enum CellType {
    case logoAmount
    case labelValue
    case image
    case descrption
    case button
    case onelineText
    case dividerText
}

class ResultVC: UIViewController {
    lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    var items: [ResultSection] = []

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.AppColors.background
        registerTableViewCells()
        setupFields()
    }

    private func setupFields() {
        self.tableView.reloadData()
    }

    private func registerTableViewCells() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(LogoAmountTableViewCell.self, forCellReuseIdentifier: LogoAmountTableViewCell.description())
        self.tableView.register(LabelValueTableViewCell.self, forCellReuseIdentifier: LabelValueTableViewCell.description())
        self.tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.description())
        self.tableView.register(DesciptionTableViewCell.self, forCellReuseIdentifier: DesciptionTableViewCell.description())
        self.tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.description())
        self.tableView.register(TextWithDividerTableViewCell.self, forCellReuseIdentifier: TextWithDividerTableViewCell.description())
    }
}

extension ResultVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.section].cells[indexPath.row]
        switch item.type {
        case .logoAmount:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LogoAmountTableViewCell.description(),
                for: indexPath) as! LogoAmountTableViewCell
            cell.leftImageView.image = UIImage(named: item.placeholder)!
            cell.rightTextLabel.text = item.value
            return cell
        case .labelValue:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LabelValueTableViewCell.description(),
                for: indexPath) as! LabelValueTableViewCell
            cell.leftTextLabel.text = item.placeholder
            cell.rightTextLabel.text = item.value
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ImageTableViewCell.description(),
                for: indexPath) as! ImageTableViewCell
            cell.appImageView.image = UIImage(named: item.value)
            return cell
        case .descrption:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DesciptionTableViewCell.description(),
                for: indexPath) as! DesciptionTableViewCell
            cell.label.text = item.value
            cell.label.textAlignment = .left
            cell.label.textColor = UIColor.AppColors.defaultBlackLabelColor
            cell.textTopAnchor?.constant = 10
            cell.textBottomAnchor?.constant = -10
            cell.label.font = UIFont.systemFont(ofSize: 17)
            return cell
        case .button:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ButtonTableViewCell.description(),
                for: indexPath) as! ButtonTableViewCell
            cell.button.setTitle(item.value, for: .normal)
            cell.button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
            return cell
        case .onelineText:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DesciptionTableViewCell.description(),
                for: indexPath) as! DesciptionTableViewCell
            cell.textTopAnchor?.constant = 0
            cell.textBottomAnchor?.constant = 0
            cell.label.text = item.value
            cell.label.textAlignment = .center
            cell.label.textColor = UIColor.AppColors.lightGray
            cell.label.font = UIFont.systemFont(ofSize: 14)
            return cell
        case .dividerText:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TextWithDividerTableViewCell.description(),
                for: indexPath) as! TextWithDividerTableViewCell
            cell.titleTextLabel.text = item.value
            return cell

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.section].cells[indexPath.row]
        switch item.type {
        case .logoAmount, .labelValue:
            return 40
        case .dividerText:
            return 50
        case .image:
            return 160
        case .descrption:
            return UITableView.automaticDimension
        case .button:
            return 60
        case .onelineText:
            return 30
        }
    }

    @objc func onButtonTap() {
        self.dismiss(animated: true)
    }
}
