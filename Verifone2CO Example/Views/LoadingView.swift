//
//  LoadingView.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

final class LoadingView: UIView {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .gray)
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        fadeIn()
        activityIndicator.startAnimating()
    }

    private func configure() {
        backgroundColor = UIColor.AppColors.background
        configureActivityIndicator()
    }

    private func configureActivityIndicator() {
        addSubview(activityIndicator)

        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func fadeIn() {
        alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0.8
        }
    }
}
