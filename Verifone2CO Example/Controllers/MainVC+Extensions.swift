//
//  MainVC+Extensions.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 06.02.2023.
//

import UIKit

// MARK: - SET COLORS
extension MainVC {
    // swiftlint: disable cyclomatic_complexity
    func configureCardFormColors() {
        if let color = getColor(key: "textfield_1000") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.primaryBackgorundColor = UIColor.systemBackground
                } else {
                    verifon2coTheme.primaryBackgorundColor = color
                }
            } else {
                verifon2coTheme.primaryBackgorundColor = color
            }
        }
        if let color = getColor(key: "textfield_1001") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.textfieldBackgroundColor = UIColor.systemBackground
                } else {
                    verifon2coTheme.textfieldBackgroundColor = color
                }
            } else {
                verifon2coTheme.textfieldBackgroundColor = color
            }
        }
        if let color = getColor(key: "textfield_1002") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.textfieldTextColor = UIColor.label
                } else {
                    verifon2coTheme.textfieldTextColor = color
                }
            } else {
                verifon2coTheme.textfieldTextColor = color
            }
        }
        if let color = getColor(key: "textfield_1003") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.labelColor = UIColor.label
                } else {
                    verifon2coTheme.labelColor = color
                }
            } else {
                verifon2coTheme.labelColor = color
            }
        }
        if let color = getColor(key: "textfield_1004") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.payButtonBackgroundColor = UIColor(hex: "#0A69C7")
                } else {
                    verifon2coTheme.payButtonBackgroundColor = color
                }
            } else {
                verifon2coTheme.payButtonBackgroundColor = color
            }
        }
        if let color = getColor(key: "textfield_1005") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.payButtonDisabledBackgroundColor = UIColor.secondaryLabel
                } else {
                    verifon2coTheme.payButtonDisabledBackgroundColor = color
                }
            } else {
                verifon2coTheme.payButtonDisabledBackgroundColor = color
            }
        }
        if let color = getColor(key: "textfield_1006") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.payButtonTextColor = UIColor.white
                } else {
                    verifon2coTheme.payButtonTextColor = color
                }
            } else {
                verifon2coTheme.payButtonTextColor = color
            }
        }
        if let color = getColor(key: "textfield_1007") {
            if #available(iOS 13.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    verifon2coTheme.cardTitleColor = UIColor.label
                } else {
                    verifon2coTheme.cardTitleColor = color
                }
            } else {
                verifon2coTheme.cardTitleColor = color
            }
        }
    }

    func getColor(key: String) -> UIColor? {
        if let value = UserDefaults.standard.string(forKey: key) {
            if let hex = Int(value, radix: 16) {
                return UIColor(hex)
            }
        }
        return nil
    }
}
