//
//  Parameters.swift
//  VerifoneSDK Example
//
//  Created by Oraz Atakishiyev on 10.11.2022.
//

import Foundation

// MARK: - Parameters
struct Parameters: Codable {
    static var shared = Parameters()

    /// tokenisation param
    var merchantCode: String?
    /// create order param
    var secretKey: String?

    enum CodingKeys: String, CodingKey {
        case merchantCode = "merchant_code"
        case secretKey = "secret_key"
    }

    var areCreditCardFieldsValid: [String: String] {
        return isValid(fields: [
            SettingCellEvent.merchantCode.rawValue,
            SettingCellEvent.secretKey.rawValue
        ])
    }

    func isValid(fields: [String]) -> [String: String] {
        let mirror = Mirror(reflecting: self)
        var properties = [String: String]()
        for child in mirror.children {
            guard let label = child.label, let value = child.value as? String else {
                continue
            }
            properties[label] = value
        }

        var invalidProperties = [String: String]()
        for field in fields {
            if let value = properties[field], !value.isEmpty {
                continue
            }
            invalidProperties[field] = properties[field] ?? ""
        }

        return invalidProperties
    }

    func validatedByPayment(_ method: AppPaymentMethodType) -> [String: String]? {
        switch method {
        case .creditCard:
            return areCreditCardFieldsValid
        default: return nil
        }
    }
}

extension Parameters {
    static var creditCard: Parameters? {
        guard let params = UserDefaults.standard.retrieve(object: Parameters.self, fromKey: AppPaymentMethodType.creditCard.rawValue) else {
            return nil
        }
        if ([params.merchantCode, params.secretKey] as [String?]).contains(where: {$0 == nil || $0!.isEmpty}) {
            return nil
        }
        return params
    }
}
