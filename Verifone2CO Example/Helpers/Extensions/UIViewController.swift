//
//  UIController+Extensions.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

private var loadingView: LoadingView?

extension UIViewController {
    func showLoadingView() {
        let loading = LoadingView(frame: view.bounds)
        view.addSubview(loading)

        loading.startAnimating()
        loadingView = loading
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
    }

    func showEmptySateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

    func alert(title: String, message: String = "") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
        CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }

    func setRightIcon(_ color: UIColor) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 30))
        let colorContainerView: UIView = UIView(frame: CGRect(x: -5, y: 0, width: 30, height: 30))
        colorContainerView.backgroundColor = color
        colorContainerView.layer.cornerRadius = 15
        colorContainerView.layer.masksToBounds = true
        colorContainerView.layer.borderWidth = 0.2
        colorContainerView.layer.borderColor = UIColor.gray.cgColor
        containerView.addSubview(colorContainerView)
        rightView = containerView
        rightViewMode = .always
    }
}
