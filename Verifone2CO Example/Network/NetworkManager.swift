//
//  NetworkManager.swift
//  Verifone2CO Example
//
//  Created by Oraz Atakishiyev on 04.01.2023.
//

import UIKit
import Verifone2CO

final class NetworkManager {
    
    static var shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    private init() {}

    func getHeaders() -> [String:String] {
        let date = Date()
        let params: Parameters! = .creditCard
        let dateString = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
        let sellerID = params?.merchantCode ?? ""
        let secretKey = params?.secretKey ?? ""
        let checkSumString = "\(sellerID.count)\(sellerID)\(dateString.count)\(dateString)"
        let hash = checkSumString.hmac(key: secretKey)

        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Avangate-Authentication": "code=\"\(sellerID)\" date=\"\(dateString)\" hash=\"\(hash)\""
        ]
    }

    func makeRequest<T: Decodable>(route: ApiEndPoint, completion: @escaping (T?, Error?) -> Void) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session: URLSession = URLSession(configuration: config)

        guard let urlRequest = route.urlRequest(with: MerchantAppConfig.shared.base2CoURL) else {
            completion(nil, AppError.badRequest("Invalid URL for: \(route)"))
            return
        }
        debugPrint("Url request: \(String(describing: urlRequest.url!.absoluteString)) headers: \(String(describing: urlRequest.allHTTPHeaderFields))")

        let task = session.dataTask(with: urlRequest) { data, response, error in
        #if DEBUG
            print("Result:\n\(String(data: data ?? Data(), encoding: .utf8) ?? "result")")
        #endif
            guard error == nil else {
                completion(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse {
                let result = self.validateResponse(data: data, urlResponse: response, error: error)
                switch result {
                case .success:
                    do {
                        guard let data = data else {
                            completion(nil, AppError.noData)
                            return
                        }
                        let decoder = JSONDecoder()
                        let decodableData: T = try decoder.decode(T.self, from: data)
                        completion(decodableData, error)
                    } catch let exception {
                        debugPrint(exception)
                        completion(nil, AppError.invalidResponse(exception.localizedDescription))
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }

        task.resume()
    }

    private func validateResponse(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, Error> {
        let decoder = JSONDecoder()
        var errorStr: String?
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(AppError.noData)
            }
        case 400...499:
            if let data = data as? Data {
                let decodableData: OrderPlaceError? = try? decoder.decode(OrderPlaceError.self, from: data)
                if let errorObj = decodableData {
                    errorStr = "\(String(describing: errorObj.errorCode)) message: \(String(describing: errorObj.message))"
                }
            }
            return .failure(AppError.badRequest(errorStr ?? error?.localizedDescription))
        case 500...599:
            return .failure(AppError.serverError(error?.localizedDescription))
        default:
            return .failure(AppError.unknown)
        }
    }
}
