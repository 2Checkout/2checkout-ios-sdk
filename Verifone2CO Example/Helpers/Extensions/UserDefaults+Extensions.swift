//
//  UserDefaults+Extensions.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 01.02.2023.
//

import Foundation
import UIKit

extension UserDefaults {

    func save<T: Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }

    func saves<T: Encodable>(customObject object: [T], inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }

    func retrieve<T: Decodable>(object type: T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }

    func retrieves<T: Decodable>(object type: [T].Type, fromKey key: String) -> [T]? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }

    func getCurrency(fromKey key: String) -> String {
        if let data = self.value(forKey: key) as? String {
            return data
        } else {
            return "USD"
        }
    }

    func booleanValue(for key: String) -> Bool {
        if let data = self.value(forKey: key) as? Bool {
            return data
        } else {
            return false
        }
    }

    func getEnv(fromKey key: String) -> String {
        if let data = self.value(forKey: key) as? String {
            return data
        } else {
            return Env.PRODUCTION.rawValue
        }
    }

    func getTesEnvUrl(fromKey key: String) -> URL? {
        if let data = self.string(forKey: key) {
            return URL(string: data)!
        } else {
            return nil
        }
    }

    func getTestEnvFromSettingsBundle(fromKey key: String) -> String? {
        guard let testEnvUrl = self.value(forKey: key) as? String else { return nil }
        if !testEnvUrl.isEmpty && UIApplication.shared.canOpenURL(URL(string: testEnvUrl)!) {
            return testEnvUrl
        }
        return nil
    }

    func getEnabledPaymentOptions() -> [AppPaymentMethodType]? {
        if let options = self.stringArray(forKey: Keys.paymentOptions) {
            return options.map { AppPaymentMethodType(rawValue: $0)! }
        }
        return nil
    }
}
