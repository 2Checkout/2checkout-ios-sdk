//
//  UIColor.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
            let chars = Array(hex.dropFirst())
            self.init(red: .init(strtoul(String(chars[0...1]), nil, 16))/255,
                      green: .init(strtoul(String(chars[2...3]), nil, 16))/255,
                      blue: .init(strtoul(String(chars[4...5]), nil, 16))/255,
                      alpha: alpha)}
    convenience init(_ rgbValue: Int) {
        self.init(
            red: CGFloat((Float((rgbValue & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((rgbValue & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((rgbValue & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0)
    }
}
