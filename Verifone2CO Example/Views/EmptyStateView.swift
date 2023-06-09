//
//  EmptyStateView.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

class EmptyStateView: UIView {
    let messageLabel = UILabel()
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(message: String) {
        super.init(frame: .zero)

        messageLabel.text = message
        configure()
    }

    private func configure() {
        configureMessage()
        configureLogo()
    }

    private func configureMessage() {
        addSubview(messageLabel)

        messageLabel.numberOfLines = 3
        messageLabel.textColor = UIColor.AppColors.secondaryLabel

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configureLogo() {
        addSubview(logoImageView)

        logoImageView.image = .appLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 100)
        ])
    }
}
