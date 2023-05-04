//
//  AnyCodingKey.swift
//  Verifone2CO Example
//

import Foundation

struct AnyCodingKey : CodingKey {
  var stringValue: String
  var intValue: Int?

  init(_ base: CodingKey) {
    self.init(stringValue: base.stringValue, intValue: base.intValue)
  }

  init(stringValue: String) {
    self.stringValue = stringValue
  }

  init(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }

  init(stringValue: String, intValue: Int?) {
    self.stringValue = stringValue
    self.intValue = intValue
  }
}
