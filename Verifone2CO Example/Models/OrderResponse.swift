//
//  OrderResponse.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 01.02.2023.
//

import Foundation

// MARK: - OrderResponse
struct OrderResponse: Codable {
    let refNo: String?
    let orderNo: Int?
    let externalReference: String?
    let status, approveStatus, merchantCode: String?
    let orderDate: String?
    let billingDetails: BillingDetails?
    let paymentDetails: PaymentResponseDetails?
    let testOrder: Bool?
    let payoutCurrency: String?
    let errors: OrderPlaceError?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case refNo = "RefNo"
        case orderNo = "OrderNo"
        case externalReference = "ExternalReference"
        case status = "Status"
        case approveStatus = "ApproveStatus"
        case merchantCode = "MerchantCode"
        case orderDate = "OrderDate"
        case billingDetails = "BillingDetails"
        case paymentDetails = "PaymentDetails"
        case testOrder = "TestOrder"
        case payoutCurrency = "PayoutCurrency"
        case errors = "Errors"
        case currency = "Currency"
    }
}

// MARK: - PaymentDetails
struct PaymentResponseDetails: Codable {
    let type, currency: String?
    let paymentMethod: PaymentResponseMethod?
    let customerIP: String?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case currency = "Currency"
        case paymentMethod = "PaymentMethod"
        case customerIP = "CustomerIP"
    }
}

// MARK: - PaymentResponseMethod
struct PaymentResponseMethod: Codable {
    let authorize3DS: Authorize3DS?
    let vendor3DSReturnURL, vendor3DSCancelURL: String?
    let firstDigits, lastDigits, cardType: String?
    let expirationMonth, expirationYear: String?
    let recurringEnabled: Bool?
    let redirectURL: String?

    enum CodingKeys: String, CodingKey {
        case authorize3DS = "Authorize3DS"
        case vendor3DSReturnURL = "Vendor3DSReturnURL"
        case vendor3DSCancelURL = "Vendor3DSCancelURL"
        case firstDigits = "FirstDigits"
        case lastDigits = "LastDigits"
        case cardType = "CardType"
        case expirationMonth = "ExpirationMonth"
        case expirationYear = "ExpirationYear"
        case recurringEnabled = "RecurringEnabled"
        case redirectURL = "RedirectURL"
    }
}

// MARK: - Authorize3DS
struct Authorize3DS: Codable {
    let href: String?
    let method: String?
    let params: Params?

    enum CodingKeys: String, CodingKey {
        case href = "Href"
        case method = "Method"
        case params = "Params"
    }
}

// MARK: - Params
struct Params: Codable {
    let avng8Apitoken: String?

    enum CodingKeys: String, CodingKey {
        case avng8Apitoken = "avng8apitoken"
    }
}

// MARK: - Error
struct OrderPlaceError: Codable {
    let errorCode, message: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message
    }
}
