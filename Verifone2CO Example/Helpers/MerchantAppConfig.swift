//
//  MerchantAppConfig.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import Foundation
import Verifone2CO

let UserDefaultsChangeNotification = UserDefaults.didChangeNotification
typealias AppPaymentMethodType = PaymentMethodType

public enum Env: String {
    case TEST
    case PRODUCTION
}

public enum Keys {
    public static var AppleLanguages = "AppleLanguages"
    public static var currency = "storedCurrency"
    public static var showCardSaveButton = "cardSwitchButton"
    public static var enable3ds = "enable3ds"
    public static var avng8apitoken = "avng8apitoken"
    public static var paymentOptions = "paymentOptions"
    public static var settingsBundleTestEnvUrl = "kTestEnvironmentUrl"
    public static var settingsBundleTestModeStatus = "kTestModeStatus"
    public static var paymentDetailsType = "EES_TOKEN_PAYMENT"
    public static var paymentDetailsTypeTest = "TEST"
}

struct MerchantAppConfig {
    // MARK: - PROPERTIES
    static var shared = MerchantAppConfig()

    var viewModel = MainViewModel()
    var userdefaults = UserDefaults.standard
    var bundle: Bundle!
    var supportedPaymentOptions: [AppPaymentMethodType] = [.creditCard, .paypal]
    var randomImageUrl = "https://api.lorem.space/image/watch?w=1300&h=800"

    public var base2CoURL: String {
        if let (urlString, _) = viewModel.isTestModeParamsOk(), urlString != nil {
            return urlString!
        } else {
            return "https://api.2checkout.com/rest/6.0/"
        }
    }
    
    public let successRetrunUrl: String = "https://www.success.com"
    public let cancelRetrunUrl: String = "https://www.fail.com"

    public var showCardSaveButton: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.showCardSaveButton)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.showCardSaveButton)
        }
    }

    public mutating func setLang(lang: String) {
        var appleLanguages = UserDefaults.standard.object(forKey: Keys.AppleLanguages) as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(lang, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: Keys.AppleLanguages)
        UserDefaults.standard.synchronize() // needs restrat
        if let languageDirectoryPath = Bundle.main.path(forResource: lang, ofType: "lproj") {
            bundle = Bundle.init(path: languageDirectoryPath)
        } else {
            resetLocalization()
        }
    }

    public mutating func getLang() -> Locale {
        let appleLanguages = UserDefaults.standard.object(forKey: Keys.AppleLanguages) as! [String]
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return Locale(identifier: array[0])
        }
        return Locale(identifier: prefferedLanguage)
    }

    public mutating func getCurrentLangName() -> String {
        return getLang().localizedString(forIdentifier: getLang().identifier)!.localizedCapitalized
    }

    public var allowedPaymentOptions: [AppPaymentMethodType] {
        mutating get {
            guard let options = userdefaults.getEnabledPaymentOptions() else {
                return supportedPaymentOptions
            }
            // keep order
            return supportedPaymentOptions.filter({
                options.contains($0)
            })
        }
    }

    mutating func resetLocalization() {
        bundle = Bundle.main
    }
    
    public var currencies: [String] {
        get {
            ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD",
             "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF",
             "BMD", "BND", "BOB", "BOV", "BRL", "BSD", "BTN", "BWP",
             "BYR", "BZD", "CAD", "CDF", "CHE", "CHF", "CHW", "CLF",
             "CLP", "CNY", "COP", "COU", "CRC", "CUC", "CVE", "CZK",
             "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR",
             "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF",
             "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR",
             "ILS", "INR", "IQD", "IRR", "ISK", "JMD", "JOD", "JPY",
             "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD",
             "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL",
             "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP",
             "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN",
             "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB",
             "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON",
             "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK",
             "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SVC",
             "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY",
             "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN", "USS",
             "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF",
             "XAG", "XAU", "XBA", "XBB", "XBC", "XBD", "XCD", "XDR",
             "XOF", "XPD", "XPF", "XPT", "XTS", "XXX", "YER", "ZAR", "ZMK", "ZMW", "BTC"]
        }
        // swiftlint: disable unused_setter_value
        set { }
    }
}

/// FORMAT HEX COLOR
func format(with mask: String, hex: String) -> String {
    let hexStr = hex.replacingOccurrences(of: "[^0-9A-Za-z]", with: "", options: .regularExpression)
    var result = ""
    var index = hexStr.startIndex

    for ch in mask where index < hexStr.endIndex {
        if ch == "X" {
            result.append(hexStr[index])
            index = hexStr.index(after: index)
        } else {
            result.append(ch)
        }
    }

    return result
}
