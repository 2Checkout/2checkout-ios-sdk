//
//  Verifone2COTests.swift
//  Verifone2COTests
//
//  Created by Oraz Atakishiyev on 03.01.2023.
//

import XCTest
@testable import Verifone2CO

// Set production merchant code
let merchantCode = ""

final class CardTokenError: XCTestCase {

    // Expected error strings
    struct ExpectedErrorStrings {
        static var invalidMerhantCode = "Bad request: 2pay-api-401-1 message: X-2Checkout-MerchantCode header invalid!"
        static var invalidCreditCardNumber = "Bad request: 2pay-api-400-3 message: Invalid Credit Card number."
        static var invalidCvv = "Bad request: 2pay-api-400-4 message: Invalid Credit Card cvv."
        static var invalidExpireDate = "Bad request: 2pay-api-400-5 message: Invalid Credit Card expiration date."
    }

    // MARK: Test empty merchant code
    func testEmptyMerchantCode() {
        let expectation = expectation(description: "Create token with empty card number")
        let card = Card(name: "John Doe", creditCard: "4111111111111111", cvv: "123", expirationDate: "02/24")
        Verifone2COPaymentForm.createToken(merchantCode: "", card: card, completion: { token, error in
            XCTAssertEqual(error as! Verifone2CoError, .invalidResponse(ExpectedErrorStrings.invalidMerhantCode))
            XCTAssertNil(token)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: Test empty card number
    func testEmptyCardNumber() {
        let expectation = expectation(description: "Create token with empty card number")
        let card = Card(name: "John Doe", creditCard: "", cvv: "123", expirationDate: "02/24")
        Verifone2COPaymentForm.createToken(merchantCode: merchantCode, card: card, completion: { token, error in
            XCTAssertEqual(error as! Verifone2CoError, .invalidResponse(ExpectedErrorStrings.invalidCreditCardNumber))
            XCTAssertNil(token)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: Test empty cvv number
    func testEmptyCVV() {
        let expectation = expectation(description: "Create token with empty cvv")
        let card = Card(name: "John Doe", creditCard: "4111111111111111", cvv: "", expirationDate: "02/24")
        Verifone2COPaymentForm.createToken(merchantCode: merchantCode, card: card, completion: { token, error in
            XCTAssertEqual(error as! Verifone2CoError, .invalidResponse(ExpectedErrorStrings.invalidCvv))
            XCTAssertNil(token)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: Test empty expire date
    func testEmptyExpireDate() {
        let expectation = expectation(description: "Create token with empty expire date")
        let card = Card(name: "John Doe", creditCard: "4111111111111111", cvv: "123", expirationDate: "")
        Verifone2COPaymentForm.createToken(merchantCode: merchantCode, card: card, completion: { token, error in
            XCTAssertEqual(error as! Verifone2CoError, .invalidResponse(ExpectedErrorStrings.invalidExpireDate))
            XCTAssertNil(token)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    // MARK: Test invalid expire date
    func testInvalidExpireDate() {
        let expectation = expectation(description: "Create token with invalid expire date")
        let card = Card(name: "John Doe", creditCard: "4111111111111111", cvv: "123", expirationDate: "02/20")
        Verifone2COPaymentForm.createToken(merchantCode: merchantCode, card: card, completion: { token, error in
            XCTAssertEqual(error as! Verifone2CoError, .invalidResponse(ExpectedErrorStrings.invalidExpireDate))
            XCTAssertNil(token)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}

class CreateTokenSuccess: XCTestCase {
    // MARK: Test success case
    func testTokenCreatedSuccessfully() {
        let expectation = expectation(description: "Create token success")
        let card = Card(name: "John Doe", creditCard: "4111111111111111", cvv: "123", expirationDate: "02/28")
        Verifone2COPaymentForm.createToken(merchantCode: merchantCode, card: card) { token, error in
            XCTAssertNil(error)
            XCTAssertNotNil(token)
            XCTAssert(!token!.token.isEmpty)
            XCTAssert(token!.token.count == 36)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
}
