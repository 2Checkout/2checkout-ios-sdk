//
//  SettingsViewModel.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 07.04.2023.
//

import Foundation
import Verifone2CO

struct SettingsViewModel {
    fileprivate var defaults = UserDefaults.standard
    fileprivate var defaultColorValues = ["FFFFFF", "FFFFFF", "000000", "364049", "007AFF", "E4E7ED", "FFFFFF", "000000"]
    
    var merchantAppConfig = MerchantAppConfig.shared
    var items: [SettingSection] = []
    var switchButtonsState: [String: Bool] = [:]
    var parameters: Parameters! = Parameters()
    var paymentDetailsType: String = Keys.paymentDetailsType {
        didSet {
            items[SettingSections.Params.rawValue].cells[0].value = self.paymentDetailsType
            self.onUpdate?(SettingSections.Params.rawValue)
        }
    }
    var onUpdate: ((Int?) -> Void)?
    var cardSecureEntry: SecureTextEtryType = .none

    init() {
        self.setupFields()
    }

    private mutating func setupFields() {
        self.items = []
        self.cardSecureEntry = SecureTextEtryType(rawValue: defaults.string(forKey: Keys.cardSecureEntry) ?? "") ?? .none
        self.items.append(SettingSection(header: "Card Form", cells: [
            SettingCellData(type: .textfield, placeholder: "Backgorund color:", value: defaults.string(forKey: "textfield_1000") ?? "FFFFFF", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Textfield background color:", value: defaults.string(forKey: "textfield_1001") ?? "FFFFFF", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Textfield text color:", value: defaults.string(forKey: "textfield_1002") ?? "000000", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Label color:", value: defaults.string(forKey: "textfield_1003") ?? "364049", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Pay button enabled color:", value: defaults.string(forKey: "textfield_1004") ?? "007AFF", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Pay button disabled color:", value: defaults.string(forKey: "textfield_1005") ?? "E4E7ED", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Pay button text color:", value: defaults.string(forKey: "textfield_1006") ?? "FFFFFF", eventType: .textfield),
            SettingCellData(type: .textfield, placeholder: "Card title color:", value: defaults.string(forKey: "textfield_1007") ?? "000000", eventType: .textfield),
            SettingCellData(type: .linkButton, placeholder: "Reset to default values", value: "Reset", eventType: .defaultValues),
            SettingCellData(type: .segmentedControl, placeholder: "Card form security entry", value: cardSecureEntry.rawValue, eventType: .cardSecurityEntry)
        ]))

        self.items.append(SettingSection(header: "", cells: [
            SettingCellData(type: .linkButton, placeholder: MerchantAppConfig.shared.getCurrentLangName(), value: "Change Language", eventType: .langChange)
        ]))

        merchantAppConfig.supportedPaymentOptions.forEach({
            switchButtonsState[$0.rawValue] = merchantAppConfig.allowedPaymentOptions.contains(AppPaymentMethodType(rawValue: $0.rawValue)!)
        })
        self.items.append(SettingSection(header: "Payment Options", cells: [
            SettingCellData(type: .switchButton,
                            placeholder: AppPaymentMethodType.creditCard.rawValue,
                            value: AppPaymentMethodType.creditCard.rawValue,
                            isOn: switchButtonsState[AppPaymentMethodType.creditCard.rawValue]!,
                            eventType: .cardParams),
            SettingCellData(type: .switchButton,
                            placeholder: AppPaymentMethodType.paypal.rawValue,
                            value: AppPaymentMethodType.paypal.rawValue,
                            isOn: switchButtonsState[AppPaymentMethodType.paypal.rawValue]!,
                            eventType: .paypal)
        ]))
        if let params = UserDefaults.standard.retrieve(object: Parameters.self, fromKey: AppPaymentMethodType.creditCard.rawValue) {
            self.parameters = params
        }
        self.items.append(SettingSection(header: "Payment parameters", cells: [
            SettingCellData(type: .linkButton, placeholder: "Payment details type", value: paymentDetailsType, eventType: .paymentDetailsType),
            SettingCellData(type: .paramTextfield, placeholder: "Merchant Code", value: self.parameters.merchantCode ?? "", eventType: .merchantCode),
            SettingCellData(type: .paramTextfield, placeholder: "Secret Key", value: self.parameters.secretKey ?? "", eventType: .secretKey),
            SettingCellData(type: .button, placeholder: "Import parameters", value: "22", eventType: .jsonImport)
        ]))
        self.paymentDetailsType = defaults.string(forKey: Keys.paymentDetailsType) ?? Keys.paymentDetailsType
        self.onUpdate?(nil)
    }

    mutating func setImportedValues() {
        // swiftlint:disable identifier_name
        for (i, header) in items.enumerated() {
            for (j, cell) in header.cells.enumerated() {
                switch cell.eventType {
                case .merchantCode:
                    items[i].cells[j].value = parameters.merchantCode ?? ""
                case .secretKey:
                    items[i].cells[j].value = parameters.secretKey ?? ""
                default: break
                }
            }
        }
    }

    mutating func resetToDefault() {
        for i in 0..<defaultColorValues.count {
            items[SettingSections.cardCustomization.rawValue].cells[i].value = defaultColorValues[i]
        }
    }

    func saveValues() {
        for i in 0..<defaultColorValues.count {
            defaults.set(items[SettingSections.cardCustomization.rawValue].cells[i].value.replacingOccurrences(of: "#", with: ""), forKey: "textfield_\(1000+i)")
        }
        
        // save payment options
        defaults.set(switchButtonsState.filter {$0.value}.map {$0.key}, forKey: Keys.paymentOptions)

        defaults.set(paymentDetailsType, forKey: Keys.paymentDetailsType)
        defaults.save(customObject: self.parameters, inKey: AppPaymentMethodType.creditCard.rawValue)

        defaults.set(cardSecureEntry.rawValue, forKey: Keys.cardSecureEntry)
    }
}

struct SettingSection {
    var header: String
    var cells: [SettingCellData]
}

struct SettingCellData {
    var type: SettingCellType
    var placeholder: String
    var value: String
    var isOn: Bool = false
    var eventType: SettingCellEvent
}

enum SettingCellType {
    case linkButton
    case switchButton
    case textfield
    case textLabel
    case paramTextfield
    case button
    case segmentedControl
}

public enum SettingCellEvent: String {
    case langChange
    case testMode
    case textfield
    case defaultValues
    case cardParams
    case paypal
    case paymentDetailsType
    case merchantCode
    case secretKey
    case jsonImport
    case cardSecurityEntry
}

enum SettingSections: Int {
    case cardCustomization = 0,
    Lang,
    Options,
    Params
}
