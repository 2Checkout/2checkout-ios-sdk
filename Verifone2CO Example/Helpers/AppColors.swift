//
//  AppColors.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

extension UIColor {
    public enum AppColors {
        public static let background: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                    if UITraitCollection.userInterfaceStyle == .dark {
                        return UIColor.systemBackground
                    } else {
                        return UIColor.systemBackground
                    }
                }
            } else {
                return UIColor.white
            }
        }()

        public static let secondaryLabel: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.secondaryLabel
            } else {
                return UIColor.darkGray
            }
        }()

        public static let blueColor: UIColor = {
            return UIColor(hex: "#0A69C7")
        }()

        public static let lightGray: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray2
            } else {
                return UIColor.lightGray
            }
        }()

        public static let defaultBlackLabelColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                return UIColor.black
            }
        }()

        public static let secondarySystemBackground: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.secondarySystemBackground
            } else {
                return UIColor.white
            }
        }()

        public static let textfieldRedColor: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor(hex: "#A20025", alpha: 0.3)
            } else {
                return UIColor(hex: "#FFEBEE")
            }
        }()

        public static let lineGray: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor(hex: "#E0E0E0")
            } else {
                return UIColor.lightGray
            }
        }()
    }
}
