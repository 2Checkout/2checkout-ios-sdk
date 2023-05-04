//
//  ApiEndPoint.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 01.02.2023.
//

import Foundation
import Verifone2CO

enum TwoCoEndPoint {
    case createOrder(headers: RequestHeaders, paramters: [String: Any?])
    case getOrder(headers: RequestHeaders, refNo: String)
}

extension TwoCoEndPoint: ApiEndPoint {
    var headers: RequestHeaders {
        switch self {
        case .createOrder(let headers, _), .getOrder(let headers, _):
            return headers
        }
    }

    var path: String {
        switch self {
        case .createOrder:
            return "orders"
        case .getOrder(_, let refNo):
            return "orders/\(refNo)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .createOrder:
            return .post
        case .getOrder:
            return .get
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case .createOrder(_, let parameters):
            return parameters
        case .getOrder:
            return nil
        }
    }
}
