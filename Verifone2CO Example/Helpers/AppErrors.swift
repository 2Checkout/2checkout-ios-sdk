//
//  AppErrors.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import Foundation

enum AppError: Error, Equatable {
    case noData
    case invalidResponse(String?)
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case canceledError(String?)
    case unknown
    case testModeEnabledUrlInvalid
    case testModeDisabled
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString(
                "No Data",
                comment: ""
            )
        case .invalidResponse(let error):
            let format = NSLocalizedString(
                "Invalid response: %@",
                comment: ""
            )
            return String(format: format, error ?? "")
        case .badRequest(let error):
            let format = NSLocalizedString(
                "Bad request: %@",
                comment: ""
            )
            return String(format: format, error ?? "")
        case .serverError(let error):
            let format = NSLocalizedString(
                "Server error: %@",
                comment: ""
            )
            return String(format: format, error ?? "")
        case .parseError(let error):
            let format = NSLocalizedString(
                "Parse error: %@",
                comment: ""
            )
            return String(format: format, error ?? "")
        case .canceledError(let error):
            let format = NSLocalizedString(
                "Cancelled error: %@",
                comment: ""
            )
            return String(format: format, error ?? "")
        case .testModeEnabledUrlInvalid:
            return NSLocalizedString(
                "Test mode env url is invalid",
                comment: ""
            )
        case .testModeDisabled:
            return NSLocalizedString(
                "Test mode disabled",
                comment: ""
            )
        case .unknown:
            return NSLocalizedString(
                "Unknown error",
                comment: ""
            )
        }
    }
}
