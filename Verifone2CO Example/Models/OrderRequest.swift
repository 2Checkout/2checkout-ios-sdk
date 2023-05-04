//
//  OrderRequest.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 01.02.2023.
//

import Foundation

// MARK: - OrderData
struct OrderData: Codable {
    var currency: String?
    let customerIP, customerReference: String
    let externalCustomerReference, externalReference, language: String
    let wsOrder: String
    let CheckRenewableProducts: Bool
    var billingDetails: BillingDetails
    var Items: [Item]?
    var paymentDetails: PaymentDetails?
}

// MARK: - BillingDetails
struct BillingDetails: Codable {
    let address1, city, countryCode, email: String?
    var firstName, lastName, phone: String?
    let state, zip: String?

    enum CodingKeys: String, CodingKey {
        case address1 = "Address1"
        case city = "City"
        case countryCode = "CountryCode"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case phone = "Phone"
        case state = "State"
        case zip = "Zip"
    }
}

// MARK: - Item
struct Item: Codable {
    let name, description: String
    let quantity: Int
    let isDynamic, tangible: Bool
    let purchaseType: String
    let price: Price
    let recurringOptions: RecurringOptions?
}

// MARK: - CrossSell
struct CrossSell: Codable {
    let campaignCode, parentCode: String
}

// MARK: - Price
struct Price: Codable {
    let amount: String
    let type: String
}

// MARK: - Option
struct Option: Codable {
    let name, value: String
    let surcharge: Int
}

// MARK: - RecurringOptions
struct RecurringOptions: Codable {
    let cycleLength: Int
    let cycleUnit: String
    let cycleAmount: Double
    let contractLength: Int
    let contractUnit: String
}

// MARK: - PaymentDetails
struct PaymentDetails: Codable {
    let currency, customerIP: String
    var paymentMethod: PaymentMethod?
    let type: String
}

// MARK: - PaymentMethod
struct PaymentMethod: Codable {
    let eesToken: String?
    let recurringEnabled: Bool?
    let vendor3DSReturnURL, vendor3DSCancelURL: String?
    let returnUrl, cancelUrl: String?

    init(eesToken: String? = nil, recurringEnabled: Bool? = nil, vendor3DSReturnURL: String? = nil, vendor3DSCancelURL: String? = nil, returnUrl: String? = nil, cancelUrl: String? = nil) {
        self.eesToken = eesToken
        self.recurringEnabled = recurringEnabled
        self.vendor3DSReturnURL = vendor3DSReturnURL
        self.vendor3DSCancelURL = vendor3DSCancelURL
        self.returnUrl = returnUrl
        self.cancelUrl = cancelUrl
    }

    enum CodingKeys: String, CodingKey {
        case eesToken = "EesToken"
        case recurringEnabled = "RecurringEnabled"
        case vendor3DSReturnURL = "Vendor3DSReturnURL"
        case vendor3DSCancelURL = "Vendor3DSCancelURL"
        case returnUrl = "ReturnURL"
        case cancelUrl = "CancelURL"
    }
}

extension BillingDetails {
    static var defaultAddress: BillingDetails = .init(
        address1: "Test Address",
        city: "LA",
        countryCode: "US",
        email: "testcustomer@2Checkout.com",
        firstName: "John",
        lastName: "Doe",
        phone: "",
        state: "California",
        zip: "12345")
}

extension OrderData {
    static var creditCard: OrderData = .init(
        currency: nil,
        customerIP: "127.0.0.1",
        customerReference: "iOS APP",
        externalCustomerReference: "REST_API_AVANGTE",
        externalReference: "REST_API_AVANGTE",
        language: "en",
        wsOrder: "testvendorOrder.com",
        CheckRenewableProducts: true,
        billingDetails: BillingDetails.defaultAddress
    )

    mutating func setupCreditCard(with token: String, paymentDetailsType: String, product: Product, currency: String, cardHolder: String?) {
        self.paymentDetails = PaymentDetails(
            currency: currency,
            customerIP: "127.0.0.1",
            paymentMethod: PaymentMethod(
                eesToken: token,
                recurringEnabled: false,
                vendor3DSReturnURL: "https://www.success.com",
                vendor3DSCancelURL: "https://www.fail.com"),
            type: paymentDetailsType)
        if let name = cardHolder?.components(separatedBy: " "), !name.isEmpty {
            self.billingDetails.firstName = name[0]
            self.billingDetails.lastName = name.count > 1 ? name[1] : ""
        }
        self.Items = [Item(
            name: product.title,
            description: product.title,
            quantity: 1,
            isDynamic: true,
            tangible: false,
            purchaseType: "PRODUCT",
            price: Price(
                amount: "\(product.price)", type: "CUSTOM"),
            recurringOptions: RecurringOptions(
                cycleLength: 2,
                cycleUnit: "Day",
                cycleAmount: 12.2,
                contractLength: 3,
                contractUnit: "DAY")
        )]
    }

    mutating func setupPaypal(product: Product, currency: String) {
        self.paymentDetails = PaymentDetails(
            currency: currency,
            customerIP: "10.11.12.1",
            paymentMethod: PaymentMethod(
                returnUrl: "https://www.success.com",
                cancelUrl: "https://www.fail.com"),
            type: "PAYPAL")
        self.Items = [Item(
            name: product.title,
            description: product.title,
            quantity: 1,
            isDynamic: true,
            tangible: false,
            purchaseType: "PRODUCT",
            price: Price(
                amount: "\(product.price)", type: "CUSTOM"),
            recurringOptions: nil
        )]
    }
}
