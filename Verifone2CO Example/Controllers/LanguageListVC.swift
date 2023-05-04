//
//  LanguageListVC.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 09.01.2023.
//

import UIKit

protocol LanguageListVCDelegate: AnyObject {
    func didSelectLanguage(selectedLanguageCode: String)
}

class LanguageListVC: UITableViewController {

    var langIds: [Locale] = []
    var languages = [Int: [String: String]]()
    weak var delegate: LanguageListVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Language"
        langIds = Bundle.main.localizations.map(Locale.init).filter { $0.identifier != "base" }
        for (index, locale) in langIds.enumerated() {
            guard let name = MerchantAppConfig.shared.getLang().localizedString(forIdentifier: locale.identifier)?.localizedCapitalized else { return }
            languages[index] = [locale.identifier: name]
        }

        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangTableViewCell", for: indexPath) as! LangTableViewCell
        guard let lang: [String: String] = languages[indexPath.row] else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "\(lang.first!.value)"
        if lang.first!.key == MerchantAppConfig.shared.getLang().identifier {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lang: [String: String] = languages[indexPath.row] {
            self.delegate?.didSelectLanguage(selectedLanguageCode: lang.first!.key)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

class LangTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
