//
//  SettingsVC.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 09.01.2023.
//

import UIKit

class SettingsVC: UIViewController {
    lazy var tableView: UITableView = {
        var tableView: UITableView!
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: CGRect.zero, style: .grouped)
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = 50.0
        return tableView
    }()

    fileprivate var currentActiveParamType: SettingCellEvent!
    fileprivate var saveBarButton: UIBarButtonItem!
    fileprivate var selectLanguageCode: String?
    fileprivate var viewModel = SettingsViewModel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Settings"
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }

    private func setupTableView() {
        self.title = "Settings"
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.tableView.showsVerticalScrollIndicator = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.saveBarButton = UIBarButtonItem(image: UIImage(named: "save"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(saveValues))
        self.saveBarButton.isEnabled = false
        self.navigationItem.rightBarButtonItems = [saveBarButton]
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.tableView.allowsSelection = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(TextFeildCell.self, forCellReuseIdentifier: TextFeildCell.description())
        self.tableView.register(LinkButtonCell.self, forCellReuseIdentifier: LinkButtonCell.description())
        self.tableView.register(TextWithSwitchCell.self, forCellReuseIdentifier: TextWithSwitchCell.description())
        self.tableView.register(TextLabelCell.self, forCellReuseIdentifier: TextLabelCell.description())
        self.tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.description())
        self.tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.description())
        self.viewModel.onUpdate = { [unowned self] section in
            guard let section = section else {
                return self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
            }
        }
    }

    @objc private func saveValues() {
        self.saveBarButton.isEnabled = false
        if let val = selectLanguageCode {
            MerchantAppConfig.shared.setLang(lang: val)
            let settingsVC = SettingsVC()
            let vcsWithoutLast = self.navigationController?.viewControllers.dropLast()
            let newVcs = Array(vcsWithoutLast!) + [settingsVC]
            self.navigationController?.setViewControllers(newVcs, animated: false)
        }
        self.viewModel.saveValues()
    }

    @objc private func defaultValues() {
        self.saveBarButton.isEnabled = true
        self.viewModel.resetToDefault()
        self.tableView.reloadData()
    }

    @objc private func endEditing() {
        self.view.endEditing(true)
    }

    @objc private func selectPDType() {
        self.saveBarButton.isEnabled = true
        let alert = UIAlertController(title: "Select payment details type", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Keys.paymentDetailsType, style: .default, handler: { [weak self] _ in
            self!.viewModel.paymentDetailsType = Keys.paymentDetailsType
        }))
        alert.addAction(UIAlertAction(title: Keys.paymentDetailsTypeTest, style: .default, handler: { [weak self] _ in
            self!.viewModel.paymentDetailsType = Keys.paymentDetailsTypeTest
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.viewModel.items[indexPath.section].cells[indexPath.row]
        switch item.type {
        case .textfield:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFeildCell.description(),
                for: indexPath) as! TextFeildCell
            cell.leftTextLabel.text = item.placeholder
            cell.textfield.delegate = self
            cell.textfield.tag = 1000+indexPath.row
            cell.setColor(value: item.value)
            return cell
        case .linkButton:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LinkButtonCell.description(),
                for: indexPath) as! LinkButtonCell
            cell.leftTextLabel.text = item.placeholder
            cell.button.setTitle(item.value, for: .normal)
            cell.infoButton.isHidden = true
            cell.actionBlock = { [weak self] in
                switch item.eventType {
                case .langChange:
                    self?.selectLanguage()
                case .defaultValues:
                    self?.defaultValues()
                case .paymentDetailsType:
                    self?.selectPDType()
                default: break
                }
            }
            return cell
        case .switchButton:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TextWithSwitchCell.description(),
                for: indexPath) as! TextWithSwitchCell
            cell.leftTextLabel.text = item.placeholder
            cell.iconView.alpha = item.eventType == .cardParams ? 1.0 : 0.0
            cell.switchButton.isOn = item.isOn
            cell.switchButton.tag = 1000 * indexPath.section + indexPath.row
            cell.switchButton.addTarget(self, action: #selector(switchButtonValueChanged), for: .valueChanged)
            return cell
        case .textLabel:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TextLabelCell.description(),
                for: indexPath) as! TextLabelCell
            cell.leftTextLabel.text = item.placeholder
            cell.isUserInteractionEnabled = true
            return cell
        case .paramTextfield:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldTableViewCell.description(),
                for: indexPath) as? TextFieldTableViewCell
            cell?.textfieldTitleLabel.text = item.placeholder
            cell?.textfield.placeholder = "----"
            cell?.textFieldTextChangeCallback = { [unowned self] text in
                self.currentActiveParamType = item.eventType
                self.textChange(text: text)
            }
            cell?.textfield.backgroundColor = UIColor.groupTableViewBackground
            cell?.textfield.text = item.value
            cell?.selectionStyle = .none
            return cell!
        case .button:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ButtonTableViewCell.description(),
                for: indexPath) as! ButtonTableViewCell
            cell.titleStr = item.placeholder
            cell.button.addTarget(self, action: #selector(browseFiles(sender:)), for: .touchUpInside)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.items[section].header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.viewModel.items[indexPath.section].cells[indexPath.row]
        switch item.type {
        case .linkButton, .switchButton, .textLabel:
            return 50.0
        case .textfield:
            return 50.0
        case .button:
            return 55.0
        case .paramTextfield:
            return 85.0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc private func switchButtonValueChanged(sender: UISwitch) {
        self.saveBarButton.isEnabled = true
        let cellModel = self.viewModel.items[sender.tag/1000].cells[sender.tag%1000]
        self.viewModel.switchButtonsState[cellModel.value] = sender.isOn
        self.viewModel.items[sender.tag/1000].cells[sender.tag%1000].isOn = sender.isOn
    }

    private func textChange(text: String) {
        self.saveBarButton.isEnabled = true
        switch currentActiveParamType {
        case .merchantCode:
            self.viewModel.parameters.merchantCode = text
        case .secretKey:
            self.viewModel.parameters.secretKey = text
        default: break
        }
    }

    @objc func browseFiles(sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.json"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet

        if let popoverPresentationController = importMenu.popoverPresentationController {
            popoverPresentationController.sourceRect = sender.bounds
        }
        self.present(importMenu, animated: true, completion: nil)
    }
}

extension SettingsVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if controller.documentPickerMode == .import {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.viewModel.parameters = try decoder.decode(Parameters.self, from: data)
                let fields = self.viewModel.parameters.validatedByPayment(.creditCard)
                if let fields = fields, !fields.isEmpty {
                    // swiftlint:disable opening_brace
                    let fieldParams = fields.map{ "\n\($0.key)" }.joined(separator: ", ")
                    self.alert(title: "Warning", message: fields.count == 1 ? "Required parameter is missing: \(fieldParams)" : "Some required parameters are missing: \(fieldParams)")
                    return
                }

                self.viewModel.setImportedValues()
                self.saveBarButton.isEnabled = true
                self.tableView.reloadData()
            } catch {
                self.alert(title: "Wrong json format", message: "An error has occurred: \(error.localizedDescription)")
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - LanguageListVCDelegate
extension SettingsVC: LanguageListVCDelegate {
    func didSelectLanguage(selectedLanguageCode: String) {
        self.selectLanguageCode = selectedLanguageCode
        let index = self.viewModel.items[SettingSections.Lang.rawValue].cells.firstIndex { data in
            data.eventType == .langChange
        }
        self.viewModel.items[SettingSections.Lang.rawValue].cells[index!].placeholder = Locale.current.localizedString(forIdentifier: selectedLanguageCode)!
        self.saveBarButton.isEnabled = true
        self.tableView.reloadData()
    }

    @objc private func selectLanguage() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageListVC") as! LanguageListVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        saveBarButton.isEnabled = true
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        let positionOriginal = textField.beginningOfDocument
        let cursorLocation = textField.position(from: positionOriginal, offset: (range.location + string.count))
        textField.text = format(with: "#XXXXXX", hex: newString).uppercased()
        if let cursorLocation = cursorLocation {
            textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
        }
        if !self.viewModel.items[SettingSections.cardCustomization.rawValue].cells.isEmpty {
            self.viewModel.items[SettingSections.cardCustomization.rawValue].cells[textField.tag-1000].value = textField.text!
        }
        if textField.text!.dropFirst().count <= 7 {
            if let hex = Int(textField.text!.dropFirst(), radix: 16) {
                textField.setRightIcon(UIColor(hex))
            }
        }
        return false
    }
}
