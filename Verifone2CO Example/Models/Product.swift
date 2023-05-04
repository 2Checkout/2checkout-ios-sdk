//
//  Product.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title: String
    var price: Double
    let productDescription: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case productDescription = "description"
        case image
    }
}
