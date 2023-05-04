//
//  Date.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 01.02.2023.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.timeZone = TimeZone(identifier: "GMT")
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
