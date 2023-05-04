//
//  UIButton.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 03.02.2023.
//

import UIKit

// MARK: - ANIMATION FOR PAY BUTTON
extension UIButton {
    func startAnimating(_ showLoading: Bool = true, originalConstraints: [NSLayoutConstraint]) {
        lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.isUserInteractionEnabled = false
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            activityIndicator.alpha = 0
            return activityIndicator
        }()

        let spinnerConst = [
            activityIndicator.widthAnchor.constraint(equalToConstant: 40.0),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40.0),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]

        let buttonConst = [
            self.widthAnchor.constraint(equalToConstant: 40.0),
            self.heightAnchor.constraint(equalToConstant: 40.0)
        ]

        if showLoading {
            NSLayoutConstraint.deactivate(originalConstraints)

            self.addSubview(activityIndicator)
            self.superview?.addConstraints(buttonConst)
            self.addConstraints(buttonConst)
            self.addConstraints(spinnerConst)

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.isUserInteractionEnabled = false
                self.layer.cornerRadius = 20.0
                activityIndicator.alpha = 1
                self.titleLabel?.alpha = 0
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                for subview in self.subviews where subview is UIActivityIndicatorView {
                    subview.removeFromSuperview()
                }
                self.removeConstraints(spinnerConst)
                self.removeConstraints(buttonConst)
                self.superview?.removeConstraints(buttonConst)
                self.superview?.addConstraints(originalConstraints)
                self.addConstraints(originalConstraints)
                NSLayoutConstraint.activate(originalConstraints)
                self.isUserInteractionEnabled = true
                self.titleLabel?.alpha = 1
                self.layer.cornerRadius = 6
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

class AppSwitchButton: UISwitch {

    // MARK: - Functions

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let height = 40.0
        let width = 20.0
        let newArea = CGRect(
            x: self.bounds.origin.x - width/2,
            y: self.bounds.origin.y - height/2,
            width: self.bounds.size.width + width,
            height: self.bounds.size.height + height
        )
        return newArea.contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
