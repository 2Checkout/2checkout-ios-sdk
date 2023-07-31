//
//  MainViewModel.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 20.03.2023.
//

import Foundation
import Verifone2CO

struct MainViewModel {
    let defaults = UserDefaults.standard
    let networkManager = NetworkManager.shared

    var currency: String {
        return defaults.getCurrency(fromKey: Keys.currency)
    }

    var cardSecureEntry: SecureTextEtryType {
        return SecureTextEtryType(rawValue: defaults.string(forKey: Keys.cardSecureEntry) ?? "") ?? .none
    }

    func isTestModeParamsOk() -> (String?, AppError?)? {
        if defaults.booleanValue(for: Keys.settingsBundleTestModeStatus) {
            if let urlString = defaults.getTestEnvFromSettingsBundle(fromKey: Keys.settingsBundleTestEnvUrl) {
                return (urlString, nil)
            } else {
                return (nil, AppError.testModeEnabledUrlInvalid)
            }
        }
        return (nil, AppError.testModeDisabled)
    }

    func getResultSection(responseItem: Any?, error: Error?, currency: String, price: Double) -> ResultSection {
        var resultSection =
        ResultSection(header: "", cells: [
            ResultCellData(type: .logoAmount, placeholder: "verifone", value: "\(price) \(currency)")
        ])
        if let error = error {
            var errorStr: String = ""
            if let errorDesc = error as? AppError {
                errorStr = errorDesc.errorDescription ?? ""
            } else if let errorSDKError = error as? Verifone2CoError {
                errorStr = errorSDKError.errorDescription ?? ""
            } else {
                errorStr = error.localizedDescription
            }
            resultSection.cells.append(ResultCellData(type: .image, placeholder: "", value: "error"))
            resultSection.cells.append(ResultCellData(type: .descrption, placeholder: "", value: errorStr))
        }
        if let item = responseItem {
            if let orderResponse = item as? OrderResponse {
                resultSection.cells.append(ResultCellData(type: .image, placeholder: "", value: "success"))
                resultSection.cells.append(ResultCellData(type: .dividerText, placeholder: "", value: "Thank you for your payment"))
                resultSection.cells.append(ResultCellData(type: .labelValue, placeholder: "Amount", value: "\(price) \(currency)"))
                resultSection.cells.append(ResultCellData(type: .labelValue, placeholder: "RefNo", value: orderResponse.refNo ?? ""))
                resultSection.cells.append(ResultCellData(type: .labelValue, placeholder: "Merchant Code", value: orderResponse.merchantCode ?? ""))
            }
        }
        resultSection.cells.append(ResultCellData(type: .button, placeholder: "", value: "Continue back to store"))
        resultSection.cells.append(ResultCellData(type: .onelineText, placeholder: "", value: "Secure payments provided by Verifone"))
        return resultSection
    }

    func get3DSWebConfig(paymentDetails: PaymentResponseDetails) -> VFWebConfig {
        let threedsDetails = paymentDetails.paymentMethod!.authorize3DS
        let expectedReturnURL = URLComponents(string: paymentDetails.paymentMethod!.vendor3DSReturnURL!)!
        let expectedCancelURL = URLComponents(string: paymentDetails.paymentMethod!.vendor3DSCancelURL!)!
        let webConfig = VFWebConfig(url: threedsDetails!.href!,
                                    parameters: [Keys.avng8apitoken: threedsDetails!.params!.avng8Apitoken!],
                                    expectedRedirectUrl: [expectedReturnURL],
                                    expectedCancelUrl: [expectedCancelURL])
        return webConfig
    }

    func getPaypalAuthWebConfig(paymentDetails: PaymentResponseDetails) -> VFWebConfig {
        let redirectUrl = paymentDetails.paymentMethod!.redirectURL!
        let expectedReturnURL = URLComponents(string: MerchantAppConfig.shared.successRetrunUrl)!
        let expectedCancelURL = URLComponents(string: MerchantAppConfig.shared.cancelRetrunUrl)!
        let webConfig = VFWebConfig(url: redirectUrl,
                                    parameters: URL(string: redirectUrl)!.queryParameters!,
                                    expectedRedirectUrl: [expectedReturnURL],
                                    expectedCancelUrl: [expectedCancelURL])
        return webConfig
    }
}

extension MainViewModel {
    // MARK: - GET RANDOM PRODUCT
    func getRandomProduct(completion: @escaping (Product?, Error?) -> Void) {
        let productId = Int.random(in: 1..<16)
        guard let output = [Product].parse(jsonFile: "products") else {
            completion(nil, AppError.noData)
            return
        }
        completion(output[productId], nil)
    }

    // MARK: - CREATE ORDER
    func createOrder(orderData: OrderData, completion: @escaping (OrderResponse?, Error?) -> Void) {
        let headers = networkManager.getHeaders()
        networkManager.makeRequest(route: TwoCoEndPoint.createOrder(headers: headers, paramters: orderData.toDictConvertWithFirstLetteCapital())) { orderResponse, error in
            completion(orderResponse, error)
        }
    }

    // MARK: - GET ORDER
    func getOrder(refNo: String, paymentMethod: AppPaymentMethodType, completion: @escaping (OrderResponse?, Error?) -> Void) {
        networkManager.makeRequest(route: TwoCoEndPoint.getOrder(headers: networkManager.getHeaders(), refNo: refNo)) { orderResponse, error in
            completion(orderResponse, error)
        }
    }
}
