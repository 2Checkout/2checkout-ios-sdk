//
//  ImageLoader.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit

class ImageLoaderView: UIImageView {
    let cache = NetworkManager.shared.cache

    static var placeholderImage: UIImage = {
        // swiftlint:disable:next force_unwrapping
        UIImage(named: "placeholder")!
    }()

    convenience init() {
        self.init()
        configure()
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = ImageLoaderView.placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }

            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }

        task.resume()
    }
}
