//
//  AppTextfield.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

class AppTextField: UITextField {
    private var insets: UIEdgeInsets {
        let edgeInsets: UIEdgeInsets = UIEdgeInsets(
                top: layoutMargins.top,
                left: layoutMargins.left,
                bottom: layoutMargins.bottom,
                right: layoutMargins.right
            )

        return edgeInsets
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: textAreaViewRect(forBounds: bounds))
    }

    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return super.clearButtonRect(forBounds: textAreaViewRect(forBounds: bounds))
    }

    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.rightViewRect(forBounds: textAreaViewRect(forBounds: bounds))
    }

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.leftViewRect(forBounds: textAreaViewRect(forBounds: bounds))
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: textAreaViewRect(forBounds: bounds))
    }

    func textAreaViewRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
