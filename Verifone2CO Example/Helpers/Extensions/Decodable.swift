//
//  Decodable.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import Foundation

extension Decodable {
  static func parse(jsonFile: String) -> Self? {
    guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let output = try? JSONDecoder().decode(self, from: data)
        else {
      return nil
    }
    return output
  }
}

extension Encodable {
    func toDictConvertWithFirstLetteCapital() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .capitalizeFirstLetter
        guard let enc = try? encoder.encode(self) else {
            return [:]
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: enc, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}

extension JSONEncoder.KeyEncodingStrategy {
  static var capitalizeFirstLetter: JSONEncoder.KeyEncodingStrategy {
    return .custom { codingKeys in
      var key = AnyCodingKey(codingKeys.last!)
      // capitalize first letter
      if let firstChar = key.stringValue.first {
        let i = key.stringValue.startIndex
        key.stringValue.replaceSubrange(
          i...i, with: String(firstChar).capitalized
        )
      }
      return key
    }
  }
}
