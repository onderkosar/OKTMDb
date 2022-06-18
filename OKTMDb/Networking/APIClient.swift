//
//  APIClient.swift
//  OKTMDb
//
//  Created by Önder Koşar on 18.06.2022.
//

import Foundation
import Alamofire

class APIClient {
    private static func handle<T: Codable>(response: AFDataResponse<Data>, completion: @escaping (AFResult<T>) -> Void) {
        if let data = response.data {
            debugPrint("------------ RESPONSE -----------")
            let str = data.prettyPrintedJSONString
            debugPrint(str ?? "UNDEFINED")
        } else {
            let networkError = RequestError.noResponse
            debugPrint("------------ ERROR -----------")
            debugPrint(networkError)
            completion(Result.failure(networkError.asAFError(orFailWith: "")))
        }
        switch response.result {
        case .success(let data):
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(model))
            } catch {
                let networkError = RequestError.decode
                debugPrint("------------ ERROR -----------")
                debugPrint(networkError)
                completion(Result.failure(networkError.asAFError(orFailWith: "")))
            }
        case .failure(let error):
            let networkError = RequestError.unexpectedStatus(code: error.responseCode)
            debugPrint("------------ ERROR -----------")
            debugPrint(networkError)
            completion(Result.failure(networkError.asAFError(orFailWith: "")))
        }
    }
    
    static func request<T: Codable>(route: APIRouter, completion: @escaping (AFResult<T>) -> Void) {
        AF.request(route).validate().responseData { response in
            handle(response: response, completion: completion)
        }
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
